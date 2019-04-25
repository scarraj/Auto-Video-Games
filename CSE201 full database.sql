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
    [gameId]      INT            NOT NULL,
    [votedUserId] NVARCHAR (128) NOT NULL,
    [commonts]    VARCHAR (MAX)  NULL,
    [userRating]  FLOAT (53)     NOT NULL
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

CREATE PROCEDURE [dbo].[calculateAvgRating]
	@game INT
AS

	UPDATE dbo.Games  
	SET Games.userRating = (
			SELECT CAST( (AVG(Cast(Commonts.userRating AS Float)))  AS DECIMAL(10,2))
			FROM Commonts, Games
			WHERE Commonts.gameId = Games.gameId AND
					Commonts.gameId = @game
		)
	WHERE Games.gameId = @game

GO

CREATE PROCEDURE getAllgames
AS
	SET NOCOUNT ON

	SELECT name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23),
		   userRating,
		   gameId
	FROM dbo.Games

GO

CREATE PROCEDURE [dbo].[getGameByName]
	@name varchar(50)
AS
	SELECT name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23),
		   userRating,
		   gameId
	FROM dbo.Games 
	WHERE name LIKE ('%' + @name + '%') OR
		  genre LIKE ('%' + @name + '%') OR
		  platforms LIKE ('%' + @name + '%') 
	ORDER BY name

GO

CREATE PROCEDURE [dbo].[loadCommonts]
	@gid int
AS
	SELECT c.*, a.Email
	FROM Commonts  c,
		 AspNetUsers  a
	WHERE c.votedUserId = a.Id AND
		gameId = @gid

GO

CREATE PROCEDURE [dbo].[SortGamesA2Z]

AS
	SELECT name,
		   genre,
		   price,
		   platforms,
		   ESRB,
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23),
		   userRating,
		   gameId
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
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23),
		   userRating,
		   gameId
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
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23),
		   userRating,
		   gameId
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
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23),
		   userRating,
		   gameId
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
		   [releaseDate] = CONVERT(VARCHAR, GETDATE(), 23),
		   userRating,
		   gameId
	FROM Games 
	ORDER BY name DESC

GO

CREATE PROCEDURE [dbo].[updateReview]
	@com varchar(max),
	@id nvarchar(128),
	@rate int,
	@gameId int
AS
	INSERT Commonts (gameId, votedUserId, commonts, userRating) VALUES
	(@gameId, @id, @com, @rate)


INSERT Games (name, genre, price, platforms, ESRB, releaseDate, userRating) VALUES
('Battlefield V', 'FPS', 59.9, 'PS4/XBOX ONE/PC', 'M', '2018/11/20', 0),
('Borderlands 3', 'FPS', 59.9, 'PS4/XBOX ONE/PC', 'M', '2019/9/13', 1),
('Anno 1800', 'STG', 59.9, 'PC', 'T' , '2019/4/16', 2),
('Mortal Combat 11', 'FTG', 59.9, 'PS4/XBOX ONE/PC', 'M', '2019/4/23', 3),
('Days Gone', 'RPG', 59.9, 'PS4', 'M', '2019/4/26', 4),
('Tales of the Neon Sea', 'Puzzle', 14.9, 'PC/SWITCH', 'T', '2019/4/30', 5),
('RAGE 2', 'FPS', 49.9, 'PS4/XBOX ONE/PC', 'M', '2019/5/14', 0),
('A Plague Tale: Innocence', 'RPG', 49.9, 'PS4/XBOX ONE/PC', 'M', '2019/5/15', 1),
('Total War: Three Kingdoms', 'STG', 49.9, 'PC', 'M', '2019/5/23', 2)