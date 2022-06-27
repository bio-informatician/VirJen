#!/usr/bin/env python
# usage : python taxanomy.py VMR37.csv fullnamelineage.dmp

import sys,os
import mysql.connector
import pandas as pd
from configparser import ConfigParser
from Bio import SeqIO
from Bio import Entrez
import subprocess
from notpull import Configuration

# set email
Entrez.email = "ebiologist@gmail.com"

config = Configuration.config

def progress(percent=0, width=40):
    left = width * percent // 100
    right = width - left

    tags = "#" * left
    spaces = " " * right
    percents = f"{percent:.0f}%"

    print("\r\t\t\t\t[", tags, spaces, "]", percents, sep="", end="", flush=True)
    
def acc2taxid(accession_number):
    if len(accession_number.split(":"))>1:
        acc=accession_number.split(":")[1]
    else:
        acc=accession_number
    
    return_value = subprocess.check_output("echo %s | epost -db nuccore -format acc | esummary | xtract -pattern DocumentSummary -element AccessionVersion TaxId" % acc, stderr=subprocess.STDOUT, shell = True)
    return(return_value)

i = 0
progress(i)

taxid_df=pd.read_csv(sys.argv[2], dtype=str, sep='|', names=['taxid', 'name','tree', 'N'])  # Open NCBI taxonomy file (fullnamelineage.dmp)
del taxid_df['N']                                                   # Shrink the dataframe
for x in ['taxid','name']:
    taxid_df[x] = taxid_df[x].str.replace('\t', '')


ask_id = "SELECT taxonomy_id FROM bioinfor_merdb.taxonomy where name='%s';"
insert_query = "INSERT INTO bioinfor_merdb.taxonomy (`taxonomy_id`, `name`, `parent_id`, `is_final_node`, `name_type`, `genbank_accession`, `ncbi_taxonid`, `baltimore_class`) VALUES (NULL, '%s', %s, '%d', '%s', '%s', '%d', '%s');"
cnx = mysql.connector.connect(**config)
cursor = cnx.cursor()

titles = ["Sort", "Isolate Sort", "Realm", "Subrealm", "Kingdom", "Subkingdom", "Phylum", "Subphylum", "Class", "Subclass", "Order", "Suborder", "Family", "Subfamily", "Genus", "Subgenus", "Species", "Exemplar or additional isolate", "Virus name(s)", "Virus name abbreviation(s)", "Virus isolate designation", "Virus GENBANK accession", "Genome coverage", "Genome composition", "Host Source"]
acc2tax_failed_list = []
acc2tax = open('acc2tax_failed_list.txt', 'w', encoding='utf-8')

with open(sys.argv[1], 'r', encoding='utf-8') as infile:                        # open ICTV VMR37.csv file
    next(infile)
    lines = infile.readlines()
counter = 0
wordtable = []
linevalue = 100/(len(lines))
for line in lines:
    i = i+linevalue
    progress(round(i))

    parent, parent_level, child = "", "", ""
    Line = line.split(",")
    for n,element in enumerate(Line):
        if 1<n<=16 and element != "" and Line[17]=="E" and element not in wordtable:
                               
            x = n
            wordtable.append(element)

            while parent == "" and x > 2:
                x = x-1
                parent = Line[x]
                parent_level = titles[x]
            else:
                pass

            counter = counter+1
            if counter >= 10:
                cnx.commit()
                cnx.close()
                cnx = mysql.connector.connect(**config)
                cursor = cnx.cursor()
                counter = 0
            else:
                pass


            if len(parent) == 0 :
                parent_id = "NULL"
            else:
                # print(parent)
                cursor.execute(ask_id % (parent))

                try:
                    parent_id=cursor.fetchone()[0]
                except:
                    print('Parent id for %s %s did not find within the database' % (parent_level, parent))

            x = n
            while child == "" and x < 16:    # Check for any child within VMR
                x = x+1
                child = Line[x]
            else:
                pass

            if child == "":      # If it is a species and there is an GenBank accession id for that
                # print(Line[21])
                end_node = 1                  # This is a leaf of the tree (no child)
            else:
                end_node = 0

            
            try:
                ncbi_taxonid = list(taxid_df[taxid_df["name"].str.contains(fr'^\b{element}\b$', regex=True, case=False)].taxid)[0]
                if ncbi_taxonid.isnumeric():
                    ncbi_taxonid=int(ncbi_taxonid)
                else:
                    print("\n error: There is no taxonomy id for %s in the FNL file" % (element))
                    
            except:
                if end_node:
                    if len(Line[18].split("; "))>1:
                        tid=[]
                        for s in Line[18].split("; "):
                            result = list(taxid_df[taxid_df["name"].str.contains(fr'^\b{s}\b$', regex=True, case=False)].taxid)
                            tid.append(result)

                    else:        
                        tid = list(taxid_df[taxid_df["name"].str.contains(fr'^\b{Line[18]}\b$', regex=True, case=False)].taxid)
                    if any(tid):
                        for t in tid:
                            if t and type(t)==list:
                                ncbi_taxonid=t[0]
                            elif t:
                                ncbi_taxonid=t
                    else:
                        ncbi_taxonid=0
                else:
                    ncbi_taxonid=0

            if end_node:
                baltimore = Line[23]
                if Line[21]:
                    genbank_accession = Line[21]
                    #print("\n******"+genbank_accession)
                    if ncbi_taxonid == 0:         # If there is no record for this virus, ask NCBI for TaxId using GenBank accession number
                        if len(genbank_accession.split(";"))>1:
                            first_acc=genbank_accession.split(";")[0]
                            return_value = acc2taxid(first_acc)
                        else:
                            return_value = acc2taxid(genbank_accession)
                        #print(return_value)
                        try:
                            ncbi_taxonid = int(return_value.decode().strip().split("\t")[1])
                        except: 
                            ncbi_taxonid = 0
                            acc2tax.write('{}, {}\n'.format(element,genbank_accession))

                    else:
                        pass
               	else:
                     genbank_accession = "NULL"
            else:
                genbank_accession = "NULL"
                baltimore = "Null"
                
                
            #print(element, parent_id, end_node, titles[n], genbank_accession, ncbi_taxonid, baltimore)
            if baltimore=='Complete genome':
                baltimore = Line[24]
            cursor.execute(insert_query % (element, parent_id, end_node, titles[n], genbank_accession, int(ncbi_taxonid), baltimore))
            parent, child = "", ""
            ncbi_taxonid = 0

cnx.commit()
cnx.close()
acc2tax.close()

