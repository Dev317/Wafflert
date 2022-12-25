import pytest


@pytest.fixture
def client():
    from src import app

    app.app.config['TESTING'] = True

    app.db.engine.execute('DROP TABLE IF EXISTS `order`;')

    app.db.engine.execute('''CREATE TABLE `order` (
  `order_id` varchar(40) NOT NULL,
  `bid_id` varchar(40),
  `orderer_user_id` varchar(40) NOT NULL,
  `runner_user_id` varchar(40),
  `orderer_username` varchar(32) NOT NULL,
  `runner_username` varchar(32),
  `flavour` varchar(128) NOT NULL,
  `quantity` int NOT NULL,
  `delivery_info` varchar(128) NOT NULL,
  `creation_datetime` DATETIME NOT NULL,
  `expiry_datetime` DATETIME NOT NULL,
  `final_bid_price` float,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;''')

    app.db.engine.execute('''INSERT INTO `order` VALUES 
('12345678-abcd-abcd-abcd-12345678ord1','12345678-abcd-abcd-abcd-12345678bid1','12345678-abcd-abcd-abcd-12345678usr1','12345678-abcd-abcd-abcd-12345678usr2','user1','user2','Cheese',1,'Deliver to SOE','2022-10-14 08:00:00', '2022-10-14 12:00:00',2.5),
('12345678-abcd-abcd-abcd-12345678ord2','12345678-abcd-abcd-abcd-12345678bid2','12345678-abcd-abcd-abcd-12345678usr1','12345678-abcd-abcd-abcd-12345678usr2','user1','user2','Strawberry',3,'Deliver to SCIS gate','2022-10-14 08:00:00', '2022-10-14 12:05:00',8),
('12345678-abcd-abcd-abcd-12345678ord3',null,'12345678-abcd-abcd-abcd-12345678usr2',null,'user2',null,'Kaya',2,'SOA L2','2022-10-14 08:00:00', '2022-10-14 12:10:00', null),
('12345678-abcd-abcd-abcd-12345678ord4',null,'12345678-abcd-abcd-abcd-12345678usr3',null,'user3',null,'PB',1,'SCIS SR 2-1','2022-10-14 08:00:00', '2022-10-14 12:15:00', null),
('12345678-abcd-abcd-abcd-12345678ord5',null,'12345678-abcd-abcd-abcd-12345678usr4',null,'user4',null,'Blueberry Cheese',4,'LKS L1','2022-10-14 08:00:00', '2022-10-14 12:20:00', null);''')

    return app.app.test_client()
