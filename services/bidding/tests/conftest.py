import pytest


@pytest.fixture
def client():
    from src import app

    app.app.config['TESTING'] = True

    app.db.engine.execute('DROP TABLE IF EXISTS `bid`;')

    app.db.engine.execute('''CREATE TABLE `bid` (
  `bid_id` varchar(40) NOT NULL,
  `order_id` varchar(40),
  `creation_datetime` DATETIME NOT NULL,
  `expiry_datetime` DATETIME NOT NULL,
  `bid_price` float NOT NULL,
  `bid_status` varchar(32) NOT NULL,
  `last_updated` DATETIME NOT NULL,
  PRIMARY KEY (`bid_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;''')

    app.db.engine.execute('''INSERT INTO `bid` VALUES 
('12345678-abcd-abcd-abcd-12345678bid1','12345678-abcd-abcd-abcd-12345678ord1','2022-10-14 08:00:00', '2022-10-14 12:00:00',2.5,'OPEN','2022-10-14 08:00:00');''')

    return app.app.test_client()
