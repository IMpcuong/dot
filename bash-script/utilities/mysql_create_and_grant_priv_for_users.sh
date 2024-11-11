#!/bin/bash

mysql <<EOF
CREATE DATABASE sample_db;
CREATE USER 'sample'@'localhost' IDENTIFIED BY 'GCP_aws^2023';

GRANT ALL PRIVILEGES ON `sample_1`.* TO 'sample'@'localhost';

GRANT ALL PRIVILEGES ON `sample_1`.* TO 'sample'@'10.11.12.13' IDENTIFIED BY 'GCP_aws^2023';
GRANT ALL PRIVILEGES ON `sample_2`.* TO 'sample'@'10.11.12.13' IDENTIFIED BY 'GCP_aws^2023';
GRANT ALL PRIVILEGES ON `sample_3`.* TO 'sample'@'10.11.12.13' IDENTIFIED BY 'GCP_aws^2023';

GRANT USAGE ON `sample_1`.* TO 'sample'@'10.11.12.13' IDENTIFIED BY 'GCP_aws^2023' WITH GRANT OPTION;

FLUSH PRIVILEGES;

REVOKE ALL PRIVILEGES ON sample_1.* FROM 'sample'@'10.11.12.13';
REVOKE ALL PRIVILEGES ON sample_2.* FROM 'sample'@'10.11.12.13';
REVOKE ALL PRIVILEGES ON sample_3.* FROM 'sample'@'10.11.12.13';

REVOKE USAGE ON `sample_1`.* FROM 'sample'@'10.11.12.13';
REVOKE USAGE, GRANT OPTION ON `sample_1`.* FROM 'sample'@'10.11.12.13';
SHOW GRANTS FOR 'sample'@'localhost';

-- Begin procedure:
DELIMITER //

CREATE PROCEDURE grant_privileges_to_usr()
BEGIN
  DECLARE db_name VARCHAR(255);
  DECLARE done INT DEFAULT FALSE;

  -- Cursor to iterate over databases:
  DECLARE db_cursor CURSOR FOR
    SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE 'sample_%';

  -- Error handler:
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  -- Open cursor and iterate over databases:
  OPEN db_cursor;
  read_loop: LOOP
    FETCH db_cursor INTO db_name;
    IF done THEN
      LEAVE read_loop;
    END IF;

    -- Grant privileges to usr for the current database:
    SET @grant_query = CONCAT('GRANT ALL PRIVILEGES ON `', db_name, '`.* TO \'sample\'@\'localhost\';');
    PREPARE stmt FROM @grant_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Grant privileges to usr for the extrinsic/external host:
    SET @grant_remote_query = CONCAT('GRANT ALL PRIVILEGES ON `', db_name, '`.* TO \'sample\'@\'10.11.12.13\' IDENTIFIED BY \'GCP_aws^2023\';');
    PREPARE stmt FROM @grant_remote_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END LOOP;

  -- Close cursor:
  CLOSE db_cursor;
END//

DELIMITER ;

CALL grant_privileges_to_usr();
EOF
