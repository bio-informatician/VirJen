-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: bioinfor_merdb
-- ------------------------------------------------------
-- Server version	8.0.29-0ubuntu0.22.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `annotation`
--

DROP TABLE IF EXISTS `annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annotation` (
  `annotation_id` int NOT NULL AUTO_INCREMENT,
  `annotation_source` varchar(32) NOT NULL,
  `annotation_code` int NOT NULL,
  `evidence_code` varchar(32) NOT NULL,
  PRIMARY KEY (`annotation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `baltimore`
--

DROP TABLE IF EXISTS `baltimore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `baltimore` (
  `baltimore_id` int NOT NULL AUTO_INCREMENT,
  `molecule_type` varchar(16) NOT NULL,
  PRIMARY KEY (`baltimore_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene`
--

DROP TABLE IF EXISTS `gene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene` (
  `gene_id` int NOT NULL AUTO_INCREMENT,
  `go_id` int NOT NULL,
  `go_term` varchar(32) NOT NULL,
  `gene_abbreviation` varchar(10) NOT NULL,
  `gene_version` int NOT NULL,
  `parent_gene_id` int NOT NULL,
  `upstream_seq` varchar(1024) NOT NULL,
  `gene_product` varchar(32) NOT NULL,
  `molecular_function` varchar(32) NOT NULL,
  PRIMARY KEY (`gene_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gene_annotation`
--

DROP TABLE IF EXISTS `gene_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gene_annotation` (
  `gene_id` int NOT NULL,
  `annotation_id` int NOT NULL,
  KEY `gene_annotation` (`gene_id`,`annotation_id`),
  KEY `annotation_id` (`annotation_id`),
  CONSTRAINT `gene_annotation_ibfk_1` FOREIGN KEY (`annotation_id`) REFERENCES `annotation` (`annotation_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `gene_annotation_ibfk_2` FOREIGN KEY (`gene_id`) REFERENCES `gene` (`gene_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `phenotypicfeature`
--

DROP TABLE IF EXISTS `phenotypicfeature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phenotypicfeature` (
  `phenotypicfeature_id` int NOT NULL AUTO_INCREMENT,
  `size` int NOT NULL,
  `molecular_weight` int NOT NULL,
  `shape` varchar(16) NOT NULL,
  `envelope` tinyint(1) NOT NULL,
  `viron_volume` int NOT NULL,
  PRIMARY KEY (`phenotypicfeature_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample`
--

DROP TABLE IF EXISTS `sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample` (
  `sample_id` int NOT NULL AUTO_INCREMENT,
  `upload_date` date NOT NULL,
  `confidencelevel` int NOT NULL DEFAULT '0',
  `taxonomy_id` int DEFAULT NULL,
  `three_prime_utr` tinyint(1) NOT NULL,
  `five_prime_utr` tinyint(1) NOT NULL,
  `variant_id` int DEFAULT NULL,
  `baltimore_id` int DEFAULT NULL,
  `phenotypicfeature_id` int DEFAULT NULL,
  `samplecomponent_id` int DEFAULT NULL,
  `sample_version` varchar(10) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `source_db` varchar(300) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
  `sample_accession_number` int DEFAULT NULL,
  `sample_name` varchar(300) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `pmid` int DEFAULT NULL,
  `publication_doi` varchar(300) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `user_assembly_level` tinyint(1) DEFAULT NULL,
  `assembler_software` varchar(32) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `assembler_version` varchar(10) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
  `user_defined_taxid` int DEFAULT NULL,
  `check_me` tinyint(1) DEFAULT NULL,
  `assembly_level` tinyint(1) DEFAULT NULL,
  `fasta_location` varchar(1024) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `collection_id` int DEFAULT NULL,
  PRIMARY KEY (`sample_id`),
  KEY `taxonomy_id` (`taxonomy_id`),
  KEY `baltimore_id` (`baltimore_id`),
  KEY `phenotypicfeature_id` (`phenotypicfeature_id`),
  CONSTRAINT `sample_ibfk_1` FOREIGN KEY (`sample_id`) REFERENCES `sample_gene` (`sample_id`),
  CONSTRAINT `sample_ibfk_2` FOREIGN KEY (`baltimore_id`) REFERENCES `baltimore` (`baltimore_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `sample_ibfk_3` FOREIGN KEY (`phenotypicfeature_id`) REFERENCES `phenotypicfeature` (`phenotypicfeature_id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `taxonomy_id` FOREIGN KEY (`taxonomy_id`) REFERENCES `taxonomy` (`taxonomy_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_gene`
--

DROP TABLE IF EXISTS `sample_gene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_gene` (
  `sample_id` int NOT NULL,
  `gene_id` int NOT NULL,
  `annotator` varchar(16) NOT NULL,
  `strand` varchar(10) NOT NULL,
  `genomic_location` varchar(16) NOT NULL,
  `start_position` int NOT NULL,
  `end_position` int NOT NULL,
  `nt_seq` varchar(1024) NOT NULL,
  `aa_seq` varchar(1024) NOT NULL,
  `seq_version` int NOT NULL,
  KEY `sample_gene` (`sample_id`,`gene_id`),
  KEY `gene_id` (`gene_id`),
  CONSTRAINT `sample_gene_ibfk_1` FOREIGN KEY (`gene_id`) REFERENCES `gene` (`gene_id`),
  CONSTRAINT `sample_gene_ibfk_2` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sample_segment`
--

DROP TABLE IF EXISTS `sample_segment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample_segment` (
  `segment_id` int NOT NULL,
  `sample_id` int NOT NULL,
  `genome_structure` varchar(10) NOT NULL,
  `segment_sequence` varchar(1024) NOT NULL,
  `sequence_length` int NOT NULL,
  `sequence_gc_content` int NOT NULL,
  `refseq_accession` varchar(10) NOT NULL,
  `genbank_accession` varchar(10) NOT NULL,
  KEY `sample_segment` (`segment_id`,`sample_id`),
  KEY `sample_id` (`sample_id`),
  CONSTRAINT `sample_segment_ibfk_1` FOREIGN KEY (`segment_id`) REFERENCES `segment` (`segment_id`),
  CONSTRAINT `sample_segment_ibfk_2` FOREIGN KEY (`sample_id`) REFERENCES `sample` (`sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `segment`
--

DROP TABLE IF EXISTS `segment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `segment` (
  `segment_id` int NOT NULL AUTO_INCREMENT,
  `segment_name` varchar(32) NOT NULL,
  PRIMARY KEY (`segment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taxonomy`
--

DROP TABLE IF EXISTS `taxonomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taxonomy` (
  `taxonomy_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `parent_id` int DEFAULT NULL,
  `is_final_node` tinyint(1) NOT NULL,
  `name_type` varchar(16) NOT NULL,
  `ncbi_taxonid` int DEFAULT NULL,
  `genbank_accession` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `baltimore_class` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`taxonomy_id`),
  KEY `parent_relation_idx` (`parent_id`),
  CONSTRAINT `parent_relation` FOREIGN KEY (`parent_id`) REFERENCES `taxonomy` (`taxonomy_id`)
) ENGINE=InnoDB AUTO_INCREMENT=350 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-15 16:26:00
