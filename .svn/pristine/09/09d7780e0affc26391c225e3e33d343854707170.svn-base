create or replace function clobfromblob(p_blob blob) return clob is
      l_clob         clob;
      l_dest_offsset integer := 1;
      l_src_offsset  integer := 1;
      l_lang_context integer := dbms_lob.default_lang_ctx;
      l_warning      integer;

   begin

      if p_blob is null then
         return null;
      end if;

      dbms_lob.createTemporary(lob_loc => l_clob
                              ,cache   => false);

      dbms_lob.converttoclob(dest_lob     => l_clob
                            ,src_blob     => p_blob
                            ,amount       => dbms_lob.lobmaxsize
                            ,dest_offset  => l_dest_offsset
                            ,src_offset   => l_src_offsset
                            ,blob_csid    => dbms_lob.default_csid
                            ,lang_context => l_lang_context
                            ,warning      => l_warning);

      return l_clob;

   end;
   ~

   CREATE OR REPLACE FUNCTION blob_to_clob(blob_in IN BLOB)
	RETURN CLOB
	AS
	v_clob CLOB;
	v_varchar VARCHAR2(32767);
	v_start PLS_INTEGER := 1;
	v_buffer PLS_INTEGER := 32767;
	BEGIN
	DBMS_LOB.CREATETEMPORARY(v_clob, TRUE);

	FOR i IN 1..CEIL(DBMS_LOB.GETLENGTH(blob_in) / v_buffer)
	LOOP

	   v_varchar := UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(blob_in, v_buffer, v_start));

	DBMS_LOB.WRITEAPPEND(v_clob, LENGTH(v_varchar), v_varchar);
	v_start := v_start + v_buffer;
	END LOOP;
	RETURN v_clob;
	END blob_to_clob;