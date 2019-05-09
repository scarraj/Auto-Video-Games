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

CREATE TABLE [dbo].[AspNetRoles] (
    [Id]   NVARCHAR (128) NOT NULL,
    [Name] NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
    ON [dbo].[AspNetRoles]([Name] ASC);
GO

CREATE TABLE [dbo].[AspNetUserRoles] (
    [UserId] NVARCHAR (128) NOT NULL,
    [RoleId] NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC),
    CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_UserId]
    ON [dbo].[AspNetUserRoles]([UserId] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_RoleId]
    ON [dbo].[AspNetUserRoles]([RoleId] ASC);
GO

CREATE TABLE [dbo].[AspNetUsers] (
    [Id]                   NVARCHAR (128) NOT NULL,
    [Email]                NVARCHAR (256) NULL,
    [EmailConfirmed]       BIT            NOT NULL,
    [PasswordHash]         NVARCHAR (MAX) NULL,
    [SecurityStamp]        NVARCHAR (MAX) NULL,
    [PhoneNumber]          NVARCHAR (MAX) NULL,
    [PhoneNumberConfirmed] BIT            NOT NULL,
    [TwoFactorEnabled]     BIT            NOT NULL,
    [LockoutEndDateUtc]    DATETIME       NULL,
    [LockoutEnabled]       BIT            NOT NULL,
    [AccessFailedCount]    INT            NOT NULL,
    [UserName]             NVARCHAR (256) NOT NULL,
    CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[AspNetUsers]([UserName] ASC);
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
GO

CREATE PROCEDURE [dbo].[getUserType]
	@id nvarchar(128)
AS
	SELECT RoleId
	FROM dbo.AspNetUserRoles
	WHERE UserId = @id
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

CREATE PROCEDURE [dbo].[addGame]
	@name varchar(50),
	@genre varchar(10),
	@price float,
	@platforms varchar(50),
	@ESRB varchar(10),
	@releaseDate date
AS
	INSERT Games(name, genre, price, platforms, ESRB, releaseDate) VALUES
	(@name, @genre, @price, @platforms, @ESRB, @releaseDate)
GO

CREATE PROCEDURE [dbo].[removeAblity]
	@email nvarchar(256)
AS
	DELETE FROM dbo.AspNetUserRoles
	WHERE UserId = (
		SELECT id
		FROM dbo.AspNetUsers
		WHERE Email = @email
	)
GO

CREATE PROCEDURE [dbo].[addAblity]
	@email nvarchar(256)
AS
	DECLARE @id uniqueidentifier 
	SET @id = (SELECT id FROM dbo.AspNetUsers WHERE Email = @email)
	INSERT INTO dbo.AspNetUserRoles(UserId, RoleId) VALUES
	(@id, 2)
GO

CREATE PROCEDURE [dbo].[loadAccount]

AS
	SELECT UserName, RoleId
	FROM dbo.AspNetUsers  a
		LEFT JOIN dbo.AspNetUserRoles  b
			ON a.Id = b.UserId
	ORDER BY RoleId		
GO

CREATE PROCEDURE [dbo].[deleteComment]
	@gameId int,
	@email nvarchar(256)
AS
	DELETE FROM dbo.Commonts
	WHERE gameId = @gameId AND
		  votedUserId = (SELECT Id FROM AspNetUsers WHERE Email = @email)
GO

INSERT AspNetUserRoles(UserId, RoleId) VALUES
('83ad586f-6f40-4643-88cc-ddabc08d6b72', '1')

INSERT AspNetUsers(Id, Email, EmailConfirmed, PasswordHash, SecurityStamp,PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, LockoutEndDateUtc, LockoutEnabled, AccessFailedCount, UserName) VALUES
('83ad586f-6f40-4643-88cc-ddabc08d6b72', 'admin@admin.com', 0, 'ANs/Su+L4/29abfSeR8FKvdR+SQHZnXrAOTXZraczQYTLxE5KT7fd4pIiucIAwGJ0Q==','49a3a7cc-aef0-49f0-aff3-b5f31f692941', NULL, 0, 0, NULL,1,0,'admin@admin.com'),
('03c65c7a-213f-4976-9324-0a100f9a8f8f', 'abc@gmail.com', 0, 'AAgFN6cw07qvuOX3w6DJCue9RwlqQg9EmVRa26jqFyAzIvsuQU2KA+mwl6DjRf/yyA==','69b68b17-d668-4441-ad82-f3d73156558a', NULL, 0, 0, NULL,1,0,'abc@gmail.com'),
('2031ae54-0168-4183-af21-82f30313c8e4', 'ab@a.com', 0, 'AFScOIRo9ghSPKWfqmSLsQccnaKPUV8qRoNhagCDXj07rbaNL2w0A9oZf7kMG/NBxQ==','dabe879a-9cf0-4ca0-bd93-ab4ddbe50006', NULL, 0, 0, NULL,1,0,'ab@a.com'),
('386eb6f0-e5dd-4c74-abb5-dac13c74cdff', 'abcd@gmial.com', 0, 'AKOHLnUDB2uGflmz1XcG+YKDWCg0tsUNzo413SMTKHza9MsCrdxEWCwdDUqSf9PHkw==','d1a3a2e0-4526-4a07-ae8a-73d5f336aa70', NULL, 0, 0, NULL,1,0,'abcd@gmial.com')
GO

INSERT Games (name, genre, price, platforms, ESRB, releaseDate, userRating) VALUES
('Battlefield V', 'FPS', 59.99, 'PS4/XBOX ONE/PC', 'M', '2018/11/20', 0),
('Borderlands 3', 'FPS', 59.99, 'PS4/XBOX ONE/PC', 'M', '2019/9/13', 1),
('Anno 1800', 'STG', 59.99, 'PC', 'T' , '2019/4/16', 2),
('Mortal Combat 11', 'FTG', 59.99, 'PS4/XBOX ONE/PC', 'M', '2019/4/23', 3),
('Days Gone', 'RPG', 59.99, 'PS4', 'M', '2019/4/26', 4),
('Tales of the Neon Sea', 'Puzzle', 14.99, 'PC/SWITCH', 'T', '2019/4/30', 5),
('RAGE 2', 'FPS', 49.99, 'PS4/XBOX ONE/PC', 'M', '2019/5/14', 0),
('A Plague Tale: Innocence', 'RPG', 49.99, 'PS4/XBOX ONE/PC', 'M', '2019/5/15', 1),
('Total War: Three Kingdoms', 'STG', 49.99, 'PC', 'M', '2019/5/23', 2)