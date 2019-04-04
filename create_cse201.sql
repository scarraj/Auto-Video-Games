USE master
GO

/****** Object: Database CSE201 ******/
IF DB_ID('CSE201') IS NOT NULL
	DROP DATABASE CSE201
GO

CREATE DATABASE CSE201
GO

USE CSE201
GO

/****** Object: TABLE GAMES ******/
CREATE TABLE Games (
	gameId		int 		 	PRIMARY KEY IDENTITY,
	name 		varchar(50) 	NOT NULL,
	genre		varchar(10)		NOT NULL,
	price		float			NOT NULL,
	platforms	varchar(50)		NOT NULL,
	ESRB		varchar(10)		NOT NULL,
	releaseDate	DATE			NOT NULL,
	userRating 	float 			NOT NULL DEFAULT 0.0
)
GO

/****** Object: TABLE Commonts ******/
CREATE TABLE Commonts (
	gameId			int				NOT NULL,
	votedUserId		int				NOT NULL,
	commonts		varchar(500),
	userRating		float			NOT NULL,
)
GO

/****** Object: TABLE Accounts ******/
CREATE TABLE Accounts (
	userId		int				PRIMARY KEY IDENTITY,
	type		varchar(10)		NOT NULL,
	name		varchar(30)		NOT NULL,
	passWord    varchar(30)		NOT NULL
)
GO


INSERT Games (name, genre, price, platforms, ESRB, releaseDate) VALUES
('Battlefield V', 'FPS', 59.9, 'PS4/XBOX ONE/PC', 'M', '2018-11-20'),
('Borderlands 3', 'FPS', 59.9, 'PS4/XBOX ONE/PC', 'M', '2019-9-13')
GO

INSERT Accounts (type, name) VALUES
('Normal', 'handsome Jack')
GO
