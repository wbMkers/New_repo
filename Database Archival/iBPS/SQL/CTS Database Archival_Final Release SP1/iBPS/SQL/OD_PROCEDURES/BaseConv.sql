CREATE Function BaseConv( @valueToConvert  int)
returns varchar(20)
AS
BEGIN
	declare @counter int
	declare @num int
	declare @x int
	declare @flag int
	declare @convertedValue  varchar(20)
	select @counter = 2;
	select @num = @valueToConvert;

	select @flag = 0;
	
	WHILE(@num != 0)
	--LOOP
	begin
		select @x = @num%36;
		IF( @x > 9) 
		begin
				IF(@flag != 1) 
				begin
					select @convertedValue = char(@x + 55);
					select @flag = 1; 
				end
				ELSE 
				begin	
					--select 1;
					select @convertedValue = char(@x + 55) + @convertedValue;	
				
				END 
				select @counter = @counter - 1;	
		end
		ELSE	
		begin	
				IF(@flag != 1) 
				begin
					--select 2;
					select @convertedValue = char(@x + 48);
					select @flag = 1; 
				end
				ELSE
				begin
					--select 3;
					select @convertedValue =  char(@x + 48) + @convertedValue;
				END 
				select @counter = @counter - 1;
		END 		
		select @num = @num / 36;
	--END LOOP;
	END
	IF(@counter != -1) 
	begin
		WHILE(@counter != -1)
		--LOOP
		begin
			IF(@flag != 1)
			begin
				select @convertedValue = char(48);
				select @flag = 1; 
			end
			ELSE
			begin
				--select 4;
				select @convertedValue = char(48) + @convertedValue ;
			END 
			select @counter = @counter - 1;
		--END LOOP;	
		END
	 END 

	return @convertedValue
END