z takich informacji:
kolosik bedzie albo 23.04 albo 07.05 (nie wiadomo jak narazie)

kontynuacja tego co robiliśmy w wcześniejszym tygodniu
---------------------------------------------------------------------------------------------------------------------------------------------------

-- deptno, dname, avg(sal), count(*)
-- jeżeli liczba pracowników < 5
-- w kolejnej kolumnie napisać 'Mało'
-- w przeciwnym razie 'Dużo'

-- case
select e.deptno, dname, AVG(sal), COUNT(*),
case
when COUNT(*)<5 then 'Mało'
else 'Dużo'
end ile
from EMP e
inner join DEPT d
on e.DEPTNO=d.DEPTNO
group by e.DEPTNO, dname

-- deptno, dname, avg(sal), count(*)
-- jeżeli liczba pracowników < 5
-- w kolejnej kolumnie napisać 'Mało'
-- jeśli liczba pracowników = 4 napisać 'Średnio'
-- w przeciwnym razie 'Dużo'

-- iif
select e.deptno, dname, AVG(sal), COUNT(*), IIF(COUNT(*)=4, 'Średnio',
iif(count(*)<4, 'Mało', 'Dużo')) ile
from EMP e
inner join DEPT d
on e.DEPTNO=d.DEPTNO
group by e.DEPTNO, dname

-- case
select e.deptno, dname, AVG(sal), COUNT(*) Liczba,
case
when COUNT(*)<4 then 'Mało'
when COUNT(*)>4 then 'Dużo'
else 'Średnio'
end ile
from EMP e
inner join DEPT d
on e.DEPTNO=d.DEPTNO
group by e.DEPTNO, dname
order by Liczba

-- ename, deptno, dname, sal, grade
select ename, e.DEPTNO, dname, sal, grade from EMP e inner join DEPT d
on e.DEPTNO=d.DEPTNO
inner join SALGRADE
on SAL between LOSAL and HISAL
order by DNAME, SAL

-- dname, liczba pracowników
select dname, COUNT(*) from EMP e inner join DEPT d
on e.DEPTNO=d.DEPTNO
group by DNAME

-- ograniczyć powyższe dla departamentów, które zatrudniają powyżej trzech pracowników (klauzula having)
select dname, COUNT(*) Liczba from EMP e inner join DEPT d
on e.DEPTNO=d.DEPTNO
group by DNAME
having COUNT(*)>3
order by Liczba

-- ograniczyć powyższe do nazw departamentów
-- rozpoczynających się od r
select dname, COUNT(*) Liczba from EMP e inner join DEPT d
on e.DEPTNO=d.DEPTNO
group by DNAME
having COUNT(*)>3 and DNAME like 'r%'
order by Liczba

-- stanowiska, na których pensja jest powyżej 2000
-- z wyjątkiem president 

select job, AVG(SAL) Średnia from EMP
where JOB <> 'President'
group by JOB
order by Średnia

select job, AVG(SAL) Średnia from EMP
group by JOB
having JOB!='President'
order by Średnia

-- grade, średnia pensja dla drugiej klasy zarobkowej
select grade, AVG(SAL) Średnia from EMP
inner join SALGRADE
on SAL between LOSAL and HISAL
where grade=2
group by GRADE

select grade, AVG(SAL) Średnia from EMP
inner join SALGRADE
on SAL between LOSAL and HISAL
group by GRADE
having grade=2

-- dla drugiej klasy zarobkowej
-- pokazać średnią pensję na każdym stanowisku
select grade, job, AVG(sal) Średnia from EMP
inner join SALGRADE
on SAL between LOSAL and HISAL
where grade=2
group by grade, job
order by Średnia

-- ograniczyć powyższe dla średniej powyżej 1270
select grade, job, AVG(sal) Średnia from EMP
inner join SALGRADE
on SAL between LOSAL and HISAL
where grade=2
group by grade, job
having AVG(sal)>1270
order by Średnia

-- dla każdego stanowiska
-- średnie, miesięczne zarobki, średnie roczne
-- średnie roczne z prowizją (jedną na rok) (prowizja = comm)
select job, AVG(sal) Miesięczne, AVG(12*SAL) Roczne, AVG(12*SAL+ISNULL(comm,0)) RoczneZProw from EMP
group by JOB
order by RoczneZProw

-- pokazać, które wartości pensji powtarzają się
-- pensja, liczba wystapien, ograniczenie na wartosci ktore sie powtarzaja
select sal, COUNT(*) Powtórzenia from EMP 
group by sal
having COUNT(*)>1

-- pokazać, ilu podwładnych ma każdey kierownik
select mgr, COUNT(*) from emp
group by mgr
order by COUNT(*)

-- numer kierownika, nazwisko kierownika, liczba pracowników
  -- !!dodany tu numer departamentu z kier możliwy na kolokwium!!

select prac.mgr, kier.ename NazwiskoSzefa, COUNT(*) Liczba from emp kier
right join EMP prac
on prac.mgr=kier.EMPNO
group by prac.mgr, kier.EMPNO
order by Liczba

-- podzapytania niepowiązane
select * from EMP order by SAL

update EMP
set SAL=800 where EMPNO=7900

-- pokaż ludzi z pensją
-- równą najbliższej pensji w firmie

select * from EMP where
SAL=(select MIN(sal) from EMP) or SAL=(select MAX(sal) from EMP)
order by SAL

select * from EMP where
SAL in ((select MIN(sal) from EMP), (select MAX(sal) from EMP))
order by SAL

select * from EMP where
SAL=(select MIN(sal) from EMP)
union
select * from EMP where
SAL=(select MAX(sal) from EMP)
order by SAL

-- pokazać ludzi z pensją poniżej średniej pensji w firmie
select * from emp where
SAL<(select AVG(sal) from EMP)

-- pokazać ludzi z pensją poniżej średniej pensji z departamentu 20
select * from emp where
SAL<(select AVG(sal) from EMP where DEPTNO=20)

-- pokazać ludzi z pensją poniżej średniej pensji z departamentu 30
-- bez ludzi z departamentu 30
select * from emp where
SAL<(select AVG(sal) from EMP where DEPTNO=20) and DEPTNO<>30

-- ludzie z departamentu 30 z pensją poniżej najniższej pensji
-- z departamentu zlokalizowanego w Dallas
select * from EMP
where sal<(select MIN(sal) from EMP e inner join DEPT d on e.DEPTNO=d.DEPTNO
where LOC='Dallas') and DEPTNO=30

select * from EMP
where SAL<(select MIN(sal) from emp
where DEPTNO=(select DEPTNO from DEPT where LOC='Dallas')) and DEPTNO=30

-- ludzie na tym samym stanowisku co Blake, bez Blake'a
select * from EMP
where JOB=(select JOB from EMP where ENAME='Blake') and ENAME<>'Blake'

-- pracownicy z pensją pomiędzy pensja Blake-500 i Blake+500
select * from EMP
where SAL between (select SAL-500 from EMP where ename='Blake')
and (select SAL+500 from emp where ENAME='Blake') and ename<>'Blake'

-- pracownicy z pensją wyższą
-- od maksymalnej pensji z departamentu 30
select * from EMP
where SAL>(select MAX(sal) from EMP where deptno=30)

select * from EMP
where SAL>all(select sal from EMP where deptno=30)

-- pracownicy z pensją wyższą
-- od minimalnej pensji z departamentu 10
select * from EMP
where SAL>(select min(sal) from EMP where deptno=10)

select * from EMP
where SAL>any(select sal from EMP where deptno=10)

-- stanowisko na którym jest najmniejszy średni zarobek
select top 1 job, AVG(sal) from emp
group by JOB
order by AVG(sal)

select job, AVG(sal) Zarobek from emp
group by JOB
having avg(sal)<=all(select AVG(sal) from EMP group by JOB)
