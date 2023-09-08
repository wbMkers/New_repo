Create or replace function BaseConv
    ( ValueIn    in varchar2    -- incoming value to convert
    , RadFrom    in number    -- source base
    , RadOut    in number    -- target base
    )
    return         varchar2    -- outgoing value in target base
is
    ValIn        varchar2(1000);
    Sign        char;
    LenIn        number;
    Base10Value    number;
    DigitPool    varchar2(50)    := '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    DigitHold    varchar(1);
    HighPower    number;
    CurrValue    number;
    CurrDigit    number;
    ResultingValue    varchar(2000);
    function GetDigit10 (InDigit in varchar2, RadIn in number) return number
    is
        bad_digit    exception;
        pragma exception_init(bad_digit,-6502);
    begin
        if InDigit = '0' then
            return 0;
        end if;
        DigitHold := upper(InDigit);
        for i in 1..RadIn-1 loop
            if DigitHold = substr(DigitPool,i,1) then
                return i;
            end if;
        end loop;
        raise_application_error(-20000,'Illegal digit, "'||InDigit||'" for base "'||RadIn||'"');
    end;
begin
    ValIn    :=    ValueIn;
    if substr(ValIn,1,1) = '-' then
        Sign    := '-';
        ValIn    := substr(ValIn,2);
    else
        Sign    := null;
    end if;
    LenIn := length(nvl(ValIn,'0'));
    Base10Value    := 0;
    for i in 1..LenIn loop
        Base10Value    := Base10Value +
            GetDigit10(substr(ValIn,i,1),RadFrom) * power(RadFrom,LenIn-i);
    end loop;
    for i in 1..1000 loop
        if power(RadOut,i) > Base10Value then
            HighPower := i-1;
            exit;
        end if;
    end loop;
    CurrValue    := Base10Value;
    ResultingValue    := null;
    for i in 0..HighPower loop
        CurrDigit := floor(Currvalue / power(RadOut,HighPower-i));
        CurrValue := Currvalue - (CurrDigit * power(RadOut,HighPower-i));
        if CurrDigit = 0 then
            ResultingValue := ResultingValue||'0';
        else
            ResultingValue := ResultingValue||substr(DigitPool,CurrDigit,1);
        end if;
    end loop;
    return sign||ResultingValue;
end;
