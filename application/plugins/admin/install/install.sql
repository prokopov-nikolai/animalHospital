CREATE TABLE prefix_d_media (
  id int(11) NOT NULL AUTO_INCREMENT,
  user_id int(11) DEFAULT NULL,
  type int(11) NOT NULL,
  target_type varchar(50) NOT NULL,
  file_path varchar(500) NOT NULL,
  file_name varchar(500) NOT NULL,
  file_size int(11) NOT NULL,
  width int(11) NOT NULL,
  height int(11) NOT NULL,
  date_add datetime NOT NULL,
  data text NOT NULL,
  PRIMARY KEY (id),
  INDEX date_add (date_add),
  INDEX file_size (file_size),
  INDEX height (height),
  INDEX target_type (target_type),
  INDEX type (type),
  INDEX user_id (user_id),
  INDEX width (width)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 8192
CHARACTER SET utf8
COLLATE utf8_general_ci;

CREATE TABLE prefix_media_target (
  id int(11) NOT NULL AUTO_INCREMENT,
  media_id int(11) NOT NULL,
  target_id int(11) DEFAULT NULL,
  target_type varchar(50) NOT NULL,
  target_tmp varchar(50) DEFAULT NULL,
  date_add datetime NOT NULL,
  is_preview tinyint(1) NOT NULL DEFAULT 0,
  data text NOT NULL,
  PRIMARY KEY (id),
  INDEX date_add (date_add),
  INDEX is_preview (is_preview),
  INDEX media_id (media_id),
  INDEX target_id (target_id),
  INDEX target_tmp (target_tmp),
  INDEX target_type (target_type)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 8192
CHARACTER SET utf8
COLLATE utf8_general_ci;