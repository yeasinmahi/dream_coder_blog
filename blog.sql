USE [master]
GO
/****** Object:  Database [dreamCoderBlog]    Script Date: 09-Jun-15 2:08:24 PM ******/
CREATE DATABASE [dreamCoderBlog]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dreamCoderBlog', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\dreamCoderBlog.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'dreamCoderBlog_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\dreamCoderBlog_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [dreamCoderBlog] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dreamCoderBlog].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [dreamCoderBlog] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ARITHABORT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [dreamCoderBlog] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [dreamCoderBlog] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET  DISABLE_BROKER 
GO
ALTER DATABASE [dreamCoderBlog] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [dreamCoderBlog] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [dreamCoderBlog] SET  MULTI_USER 
GO
ALTER DATABASE [dreamCoderBlog] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [dreamCoderBlog] SET DB_CHAINING OFF 
GO
ALTER DATABASE [dreamCoderBlog] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [dreamCoderBlog] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [dreamCoderBlog]
GO
/****** Object:  Table [dbo].[comment]    Script Date: 09-Jun-15 2:08:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[comment](
	[cid] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NOT NULL,
	[pid] [int] NOT NULL,
	[dateOfComment] [date] NULL,
	[comment] [varchar](max) NOT NULL,
 CONSTRAINT [PK_comment] PRIMARY KEY CLUSTERED 
(
	[cid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[login]    Script Date: 09-Jun-15 2:08:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[login](
	[lid] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_login] PRIMARY KEY CLUSTERED 
(
	[lid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[post]    Script Date: 09-Jun-15 2:08:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[post](
	[pid] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](200) NULL,
	[post] [varchar](max) NOT NULL,
	[dateOfPost] [datetime] NULL,
	[hitCount] [int] NULL,
	[status] [varchar](1) NULL,
	[uid] [int] NOT NULL,
 CONSTRAINT [PK_post] PRIMARY KEY CLUSTERED 
(
	[pid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[userInfo]    Script Date: 09-Jun-15 2:08:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[userInfo](
	[uid] [int] IDENTITY(1,1) NOT NULL,
	[fName] [varchar](50) NOT NULL,
	[lName] [varchar](50) NOT NULL,
	[about] [varchar](500) NULL,
	[image] [varchar](10) NULL,
	[lid] [int] NOT NULL,
 CONSTRAINT [PK_userInfo] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[login] ON 

INSERT [dbo].[login] ([lid], [email], [password]) VALUES (1, N'yeasinmahi72@yahoo.com', N'arafat7218')
INSERT [dbo].[login] ([lid], [email], [password]) VALUES (3, N'tarikseo@gmail.com', N'tarik')
SET IDENTITY_INSERT [dbo].[login] OFF
SET IDENTITY_INSERT [dbo].[post] ON 

INSERT [dbo].[post] ([pid], [title], [post], [dateOfPost], [hitCount], [status], [uid]) VALUES (4, N'Yeasin', N'<p style="text-align: center;"><span style="font-size: 52px;"><u><em><strong>I am CSE Student</strong></em></u></span></p>', CAST(0x0000A4B200662B4F AS DateTime), 0, N's', 1)
SET IDENTITY_INSERT [dbo].[post] OFF
SET IDENTITY_INSERT [dbo].[userInfo] ON 

INSERT [dbo].[userInfo] ([uid], [fName], [lName], [about], [image], [lid]) VALUES (1, N'Yeasin', N'Arafat', N'I am CSE student of AIUB', N'1.jpg', 1)
INSERT [dbo].[userInfo] ([uid], [fName], [lName], [about], [image], [lid]) VALUES (3, N'Tarik', N'Rahman', NULL, N'0.jpg', 3)
SET IDENTITY_INSERT [dbo].[userInfo] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_login]    Script Date: 09-Jun-15 2:08:25 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_login] ON [dbo].[login]
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[comment] ADD  CONSTRAINT [DF_comment_dateOfDate]  DEFAULT (getdate()) FOR [dateOfComment]
GO
ALTER TABLE [dbo].[post] ADD  CONSTRAINT [DF_post_title]  DEFAULT ('untitled') FOR [title]
GO
ALTER TABLE [dbo].[post] ADD  CONSTRAINT [DF_post_dateOfPost]  DEFAULT (getdate()) FOR [dateOfPost]
GO
ALTER TABLE [dbo].[post] ADD  CONSTRAINT [DF_post_hitCount]  DEFAULT ((0)) FOR [hitCount]
GO
ALTER TABLE [dbo].[post] ADD  CONSTRAINT [DF_post_satatus]  DEFAULT ('s') FOR [status]
GO
ALTER TABLE [dbo].[userInfo] ADD  CONSTRAINT [DF_userInfo_image]  DEFAULT ('0.jpg') FOR [image]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_post] FOREIGN KEY([pid])
REFERENCES [dbo].[post] ([pid])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_post]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_userInfo] FOREIGN KEY([uid])
REFERENCES [dbo].[userInfo] ([uid])
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_userInfo]
GO
ALTER TABLE [dbo].[post]  WITH CHECK ADD  CONSTRAINT [FK_post_userInfo] FOREIGN KEY([uid])
REFERENCES [dbo].[userInfo] ([uid])
GO
ALTER TABLE [dbo].[post] CHECK CONSTRAINT [FK_post_userInfo]
GO
ALTER TABLE [dbo].[userInfo]  WITH CHECK ADD  CONSTRAINT [FK_userInfo_login] FOREIGN KEY([lid])
REFERENCES [dbo].[login] ([lid])
GO
ALTER TABLE [dbo].[userInfo] CHECK CONSTRAINT [FK_userInfo_login]
GO
USE [master]
GO
ALTER DATABASE [dreamCoderBlog] SET  READ_WRITE 
GO
