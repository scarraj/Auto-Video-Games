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

CREATE TABLE [dbo].[Commonts] (
    [gameId]      INT           NOT NULL,
    [votedUserId] INT           NOT NULL,
    [commonts]    VARCHAR (500) NULL,
    [userRating]  FLOAT (53)    NOT NULL
);

CREATE TABLE [dbo].[Games] (
    [gameId]      INT          IDENTITY (1, 1) NOT NULL,
    [name]        VARCHAR (50) NOT NULL,
    [genre]       VARCHAR (10) NOT NULL,
    [price]       FLOAT (53)   NOT NULL,
    [platforms]   VARCHAR (50) NOT NULL,
    [ESRB]        VARCHAR (10) NOT NULL,
    [releaseDate] DATE         NOT NULL,
    [userRating]  FLOAT (53)   DEFAULT ((0.0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([gameId] ASC)
);

GO
CREATE PROCEDURE getAllgames
AS
	SET NOCOUNT ON

	SELECT name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23)
	FROM dbo.Games

GO
CREATE PROCEDURE [dbo].[getGameByName]
	@name char(50)
AS
	SELECT name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23) 
	FROM dbo.Games 
	WHERE name = @name 
	ORDER BY name

GO
CREATE PROCEDURE [dbo].[SortGamesA2Z]

AS
	SELECT name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23)
	FROM Games 
	ORDER BY name

GO
CREATE PROCEDURE [dbo].[sortGamesByGenre]

AS
	SELECT name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23) 
	FROM Games
	ORDER BY genre

GO
CREATE PROCEDURE [dbo].[sortGamesByPrice]

AS
	SELECT name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23) 
	FROM Games
	ORDER BY price

GO
CREATE PROCEDURE [dbo].[sortGamesByRate]

AS
	SELECT TOP(5) name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23) 
	FROM Games
	ORDER BY userRating DESC

GO
CREATE PROCEDURE [dbo].[SortGamesZ2A]

AS
	SELECT name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23) 
	FROM Games 
	ORDER BY name DESC
GO

INSERT Games (name, genre, price, platforms, ESRB, releaseDate, userRating) VALUES 
('A', 'FPS', 39.9 , 'PS4/PC', 'M', '2077-12-31' , 5),
('B', 'TPS', 29.9 , 'XBOX ONE/PC', 'T', '2077-12-31' , 3),
('C', 'MOBA', 59.9 , 'PS4/SWITCH', 'C', '2077-12-31' , 2),
('D', 'MMO', 59.9 , 'PC', 'T', '2077-12-31' , 1),
('E', 'RPG', 99.9 , 'PC', 'N', '2077-12-31' , 4),
('F', 'SHOTER', 19.9 , 'SWITCH', 'T', '2077-12-31' , 4)
