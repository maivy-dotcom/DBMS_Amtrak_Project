USE BUDT703_Project_0507_11;

DROP TABLE IF EXISTS [Amtrak.Ridership]
DROP TABLE IF EXISTS [Amtrak.Consist]
DROP TABLE IF EXISTS [Amtrak.OTP]
DROP TABLE IF EXISTS [Amtrak.Route]
DROP TABLE IF EXISTS [Amtrak.Station]
DROP TABLE IF EXISTS [Amtrak.Employment]
DROP TABLE IF EXISTS [Amtrak.Rewards]
DROP TABLE IF EXISTS [Amtrak.State]

CREATE TABLE [Amtrak.State](
	stateCode CHAR(2) NOT NULL,
	stateName VARCHAR(55),
	CONSTRAINT pk_State_stateCode PRIMARY KEY (stateCode));

CREATE TABLE [Amtrak.Rewards](
	stateCode CHAR(2) NOT NULL, 
	rewardsYear INT NOT NULL, 
	rewardsMembers INT,
	CONSTRAINT pk_Rewards_stateCode_rewardsYear PRIMARY KEY(stateCode,  rewardsYear),
	CONSTRAINT fk_Rewards_stateCode FOREIGN KEY(stateCode)
		REFERENCES [Amtrak.State] (stateCode)
		ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE [Amtrak.Employment] (
	stateCode CHAR(2) NOT NULL,
	empYear INT NOT NULL,
	empCount INT,
	empExpenditure DECIMAL(12,2),
	CONSTRAINT pk_Employment_empYear_stateCode PRIMARY KEY (empYear,stateCode),
	CONSTRAINT fk_Employment_stateCode FOREIGN KEY (stateCode)
		REFERENCES [Amtrak.State](stateCode) ON DELETE CASCADE ON UPDATE CASCADE) ;

CREATE TABLE [Amtrak.Station](
	stationCode CHAR(3) NOT NULL,
	stationName VARCHAR(55),
	stationCity VARCHAR(25),
	stationStateCode CHAR(2) NOT NULL,
	CONSTRAINT pk_station_stationCode PRIMARY KEY (stationCode),
	CONSTRAINT fk_station_stationStateCode FOREIGN KEY (stationStateCode)
	REFERENCES [Amtrak.State](stateCode) 
		ON DELETE NO ACTION ON UPDATE CASCADE);

CREATE TABLE [Amtrak.Route](
	routeID CHAR(4) NOT NULL,
	routeName VARCHAR(35), 
	routeType VARCHAR(20),
	CONSTRAINT pk_Route_routeID PRIMARY KEY(routeID) );

CREATE TABLE [Amtrak.OTP](
	routeID CHAR(4) NOT NULL,
	OTPYear INT NOT NULL, 
	OTP DECIMAL(3,3),
	CONSTRAINT pk_OTP_routeID_OTPYear PRIMARY KEY(routeID, OTPYear),
	CONSTRAINT fk_OTP_routeID FOREIGN KEY (routeID)
		REFERENCES [Amtrak.Route](routeID) 
		ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE [Amtrak.Consist](
	routeID CHAR(4) NOT NULL,
	stationCode CHAR(3) NOT NULL,
	CONSTRAINT pk_Consist_routeID_stationCode PRIMARY KEY (routeID,stationCode),
	CONSTRAINT fk_Consist_routeID FOREIGN KEY (routeID)
		REFERENCES [Amtrak.Route](routeID) 
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Consist_stationCode FOREIGN KEY (stationCode)
		REFERENCES  [Amtrak.Station](stationCode) 
		ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE [Amtrak.Ridership] (
	stationCode CHAR(3) NOT NULL,
	ridershipYear INT NOT NULL,
	ridershipCount INT,
	CONSTRAINT pk_Ridership_ridershipYear_stationCode PRIMARY KEY (ridershipYear,stationCode),
	CONSTRAINT fk_Ridership_stationCode FOREIGN KEY (stationCode)
	REFERENCES [Amtrak.Station](stationCode) 
		ON DELETE CASCADE ON UPDATE CASCADE) ;

INSERT INTO [Amtrak.State] VALUES
	('AL', 'Alabama'),
	('AZ', 'Arizona');

INSERT INTO [Amtrak.Rewards] VALUES 
	('AL', 2021, 36069),
	('AZ', 2021, 75061);

INSERT INTO [Amtrak.Employment] VALUES
	('AL',2023, 27, 1983661.00),
	('AZ',2023, 28, 2460877.00);

INSERT INTO [Amtrak.Station] VALUES
	('ATN','Anniston','Anniston','AL'),
	('BEN','Benson','Benson','AZ');

INSERT INTO [Amtrak.Route] VALUES 
	('R013', 'Crescent', 'Long Distance'),
	('R038', 'Sunset Limited', 'Long Distance');

INSERT INTO [Amtrak.OTP] VALUES
	('R013',2021,0.546),
	('R038',2021,0.271);

INSERT INTO [Amtrak.Consist] VALUES
	('R013', 'ATN'),
	('R038', 'BEN');

INSERT INTO [Amtrak.Ridership] VALUES
	('ATN',2021,1948),
	('BEN',2021,1224);





