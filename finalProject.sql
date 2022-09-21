CREATE OR REPLACE PROCEDURE insert_movie(
	   p_movieid IN mm_movie.movie_ID%TYPE,
	   p_movietitle IN mm_movie.movie_title%TYPE,
	   p_moviecatid IN mm_movie.movie_cat_id%TYPE,
       p_movie_value IN mm_movie.movie_value%TYPE,
	   p_movieqty IN mm_movie.movie_qty%TYPE)
IS
BEGIN

  INSERT INTO mm_movie VALUES (p_movieid, p_movietitle,p_moviecatid, p_movie_value,p_movieqty);

  COMMIT;

END;

BEGIN
  insert_movie(15,'test',4,16,10);
END;



CREATE OR REPLACE PROCEDURE insert_member(
	   p_memberid IN mm_member.member_ID%TYPE,
	   p_last IN mm_member.last%TYPE,
	   p_first IN mm_member.first%TYPE,
       p_licenseNO IN mm_member.license_no%TYPE,
	   p_licenseST IN mm_member.license_st%TYPE,
        p_creditCard IN mm_member.credit_card%TYPE,
        p_suspension IN mm_member.suspension%TYPE,
        p_mailingList IN mm_member.mailing_list%TYPE)
IS
BEGIN

  INSERT INTO mm_member VALUES (p_memberid, p_last,p_first, p_licenseNO,p_licenseST,p_creditCard,p_suspension,p_mailingList);

  COMMIT;

END;

BEGIN
  insert_member(15,'test','test2',16,'st',123456789123,'n','y');
END;

create or replace FUNCTION update_movie
    ( selected_movieid IN mm_movie.movie_ID%TYPE,
        p_movieid IN mm_movie.movie_ID%TYPE,
	   p_movietitle IN mm_movie.movie_title%TYPE,
	   p_moviecatid IN mm_movie.movie_cat_id%TYPE,
       p_movie_value IN mm_movie.movie_value%TYPE,
	   p_movieqty IN mm_movie.movie_qty%TYPE)
    RETURN varchar2
AS
    lv_row_updated varchar2(300);
BEGIN
    
    UPDATE mm_movie
    SET movie_id = p_movieid,
    movie_title = p_movietitle,
    movie_cat_id = p_moviecatid,
    movie_value = p_movie_value,
    movie_qty = p_movieqty
    WHERE movie_id = selected_movieid;
    
    lv_row_updated := selected_movieid;
    
    RETURN lv_row_updated;
end update_movie;


DECLARE 
   c varchar2(300); 
BEGIN 
   c := update_movie(20,15,'testU',5,17,11); 
   dbms_output.put_line('movie id updated ' || c); 
END; 

create or replace FUNCTION delete_movie
    ( selected_movieid IN mm_movie.movie_ID%TYPE)
    RETURN varchar2
AS
    lv_row_updated varchar2(300);
BEGIN
    
    DELETE FROM mm_movie
    WHERE movie_id = selected_movieid;
    
    lv_row_updated := selected_movieid;
    
    RETURN lv_row_updated;
end delete_movie;


DECLARE 
   c varchar2(300); 
BEGIN 
   c := delete_movie(20); 
   dbms_output.put_line('movie id deleted ' || c); 
END; 

create or replace FUNCTION update_member
    ( selected_memberid IN mm_member.member_ID%TYPE,
        p_memberid IN mm_member.member_ID%TYPE,
	   p_last IN mm_member.last%TYPE,
	   p_first IN mm_member.first%TYPE,
       p_licenseNO IN mm_member.license_no%TYPE,
	   p_licenseST IN mm_member.license_st%TYPE,
        p_creditCard IN mm_member.credit_card%TYPE,
        p_suspension IN mm_member.suspension%TYPE,
        p_mailingList IN mm_member.mailing_list%TYPE)
    RETURN varchar2
AS
    lv_row_updated varchar2(300);
BEGIN
    
    UPDATE mm_member
    SET member_id = p_memberid,
    last = p_last,
    first = p_first,
    license_no = p_licenseNO,
    license_st = p_licenseST,
    credit_card =p_creditCard ,
    suspension = p_suspension,
    mailing_list = p_mailingList
    
    
    WHERE member_id = selected_memberid;
    
    lv_row_updated := selected_memberid;
    
    RETURN lv_row_updated;
end update_member;


DECLARE 
   c varchar2(300); 
BEGIN 
   c := update_member(15,16,'testa','test2',16,'st',123456789123,'n','y'); 
   dbms_output.put_line('member id updated ' || c); 
END; 

create or replace FUNCTION delete_member
    (selected_memberid IN mm_member.member_ID%TYPE)
    RETURN varchar2
AS
    lv_row_updated varchar2(300);
BEGIN
    
    DELETE FROM mm_member
    WHERE member_id = selected_memberid;
    
    lv_row_updated := selected_memberid;
    
    RETURN lv_row_updated;
end delete_member;


DECLARE 
   c varchar2(300); 
BEGIN 
   c := delete_member(16); 
   dbms_output.put_line('member id deleted ' || c); 
END; 

create or replace FUNCTION rent_movie
    ( selected_memberid IN mm_member.member_ID%TYPE,
    selected_movieid IN mm_member.member_ID%TYPE,
    selected_pay IN mm_rental.payment_methods_id%TYPE)
    RETURN number
AS
    cur sys_refcursor;
  cur_rec mm_rental%rowtype;
  
  lv_total_count number(4);
    lv_row_updated varchar2(300);
BEGIN
    OPEN cur FOR
  SELECT * FROM mm_rental;
  LOOP
    FETCH cur INTO cur_rec;  
    EXIT WHEN cur%notfound;
    --dbms_output.put_line(cur%rowcount);--will return row number beginning with 1
    
  END LOOP;
    lv_total_count := cur%rowcount + 1;
  --dbms_output.put_line('Total Rows: ' || cur%rowcount);--here you will get total row count
  --dbms_output.put_line('Total Rows: ' || lv_total_count);
 
    
    
    INSERT INTO mm_rental VALUES (lv_total_count, selected_memberid,selected_movieid, sysdate,sysdate,selected_pay);
    RETURN lv_total_count;
    
end rent_movie;

DECLARE 
   c number(4); 
BEGIN 
   c := rent_movie(14,3,3); 
   dbms_output.put_line('member id updated ' || c); 
END;

CREATE OR REPLACE TRIGGER update_movie_qty 
after INSERT ON mm_rental 
FOR EACH ROW
BEGIN 
   UPDATE mm_movie
SET    movie_qty = movie_qty -1
where movie_id = :new.movie_id;    
END; 

create or replace FUNCTION return_movie
    (selected_memberid IN mm_member.member_ID%TYPE,
    selected_movieid IN mm_member.member_ID%TYPE)
    RETURN varchar2
AS
    lv_row_updated varchar2(300);
BEGIN
    
    DELETE FROM mm_rental
    WHERE member_id = selected_memberid and movie_id = selected_movieid;
    
    lv_row_updated := selected_memberid;
    
    UPDATE mm_movie
    SET movie_qty = movie_qty +1
    where movie_id = selected_movieid;    
    
    RETURN lv_row_updated;
end return_movie;

DECLARE 
   c varchar2(300); 
BEGIN 
   c := return_movie(14,3); 
   dbms_output.put_line('member id updated ' || c); 
END;
