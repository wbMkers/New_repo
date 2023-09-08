USE [testen]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_String_Scramble]    Script Date: 2/14/2020 8:07:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_String_Scramble]
(@InputData NVARCHAR (MAX))
RETURNS NVARCHAR (MAX) WITH ENCRYPTION
AS
BEGIN
    DECLARE @ScrambledData AS NVARCHAR (MAX);
    DECLARE @DataLength AS INT;
    DECLARE @SplitChar AS VARCHAR (1);
    DECLARE @ModifiedChar AS VARCHAR (1);
    DECLARE @ASCIIValue AS INT;
    BEGIN
        SET @DataLength = LEN(@InputData);
        SET @ScrambledData = '';
        SET @SplitChar = RIGHT(@InputData, @DataLength);
        SET @ASCIIValue = ASCII(@SplitChar);
        SET @ASCIIValue = @ASCIIValue + 5;
        SET @ModifiedChar = CHAR(@ASCIIValue);
        SET @ScrambledData = @ScrambledData + @ModifiedChar;
        WHILE (@DataLength > 1)
            BEGIN
                SET @SplitChar = RIGHT(@InputData, @DataLength - 1);
                SET @ASCIIValue = ASCII(@SplitChar);
                SET @ASCIIValue = @ASCIIValue + 5;
                SET @ModifiedChar = CHAR(@ASCIIValue);
                SET @ScrambledData = @ScrambledData + @ModifiedChar;
                SET @DataLength = @DataLength - 1;
            END
        RETURN @ScrambledData;
    END
END

GO


