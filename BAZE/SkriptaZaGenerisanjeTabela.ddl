-- Generated by Oracle SQL Developer Data Modeler 21.4.1.349.1605
--   at:        2022-01-18 18:28:54 CET
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



DROP TABLE aparat CASCADE CONSTRAINTS;

DROP TABLE cenovnik CASCADE CONSTRAINTS;

DROP TABLE klijent CASCADE CONSTRAINTS;

DROP TABLE kozmeticka_oprema CASCADE CONSTRAINTS;

DROP TABLE kozmeticki_strucnjak CASCADE CONSTRAINTS;

DROP TABLE nudi CASCADE CONSTRAINTS;

DROP TABLE obavlja_se CASCADE CONSTRAINTS;

DROP TABLE odrzava CASCADE CONSTRAINTS;

DROP TABLE preparat CASCADE CONSTRAINTS;

DROP TABLE pripada CASCADE CONSTRAINTS;

DROP TABLE racun CASCADE CONSTRAINTS;

DROP TABLE radnik CASCADE CONSTRAINTS;

DROP TABLE raspored CASCADE CONSTRAINTS;

DROP TABLE recepcioner CASCADE CONSTRAINTS;

DROP TABLE salon_lepote CASCADE CONSTRAINTS;

DROP TABLE serviser CASCADE CONSTRAINTS;

DROP TABLE termin CASCADE CONSTRAINTS;

DROP TABLE usluga CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE aparat (
    id_ko INTEGER NOT NULL
);

ALTER TABLE aparat ADD CONSTRAINT aparat_pk PRIMARY KEY ( id_ko );

CREATE TABLE cenovnik (
    dat_p         DATE NOT NULL,
    cena_usl      FLOAT NOT NULL,
    dat_z         DATE,
    usluga_id_usl INTEGER NOT NULL
);

ALTER TABLE cenovnik ADD CONSTRAINT cenovnik_pk PRIMARY KEY ( dat_p,
                                                              usluga_id_usl );

CREATE TABLE klijent (
    id_kl  INTEGER NOT NULL,
    ime_kl VARCHAR2(20) NOT NULL,
    prz_kl VARCHAR2(20) NOT NULL,
    tel_kl VARCHAR2(20)
);

ALTER TABLE klijent ADD CONSTRAINT klijent_pk PRIMARY KEY ( id_kl );

CREATE TABLE kozmeticka_oprema (
    id_ko           INTEGER NOT NULL,
    naz_ko          VARCHAR2(20) NOT NULL,
    tip_ko          VARCHAR2(17) NOT NULL,
    kol_ko          INTEGER NOT NULL,
    pro_ko          VARCHAR2(20),
    salon_lepote_mb INTEGER NOT NULL
);

ALTER TABLE kozmeticka_oprema
    ADD CONSTRAINT ch_inh_kozmeticka_oprema CHECK ( tip_ko IN ( 'Aparat', 'Kozmeticka_oprema', 'Preparat' ) );

ALTER TABLE kozmeticka_oprema ADD CONSTRAINT kozmeticka_oprema_pk PRIMARY KEY ( id_ko );

CREATE TABLE kozmeticki_strucnjak (
    mbr        INTEGER NOT NULL,
    sertifikat CHAR(1),
    edukator   INTEGER,
    mb         INTEGER NOT NULL
);

ALTER TABLE kozmeticki_strucnjak ADD CONSTRAINT kozmeticki_strucnjak_pk PRIMARY KEY ( mbr,
                                                                                      mb );

CREATE TABLE nudi (
    usluga_id_usl            INTEGER NOT NULL,
    kozmeticki_strucnjak_mbr INTEGER NOT NULL,
    kozmeticki_strucnjak_mb  INTEGER NOT NULL
);

ALTER TABLE nudi
    ADD CONSTRAINT nudi_pk PRIMARY KEY ( usluga_id_usl,
                                         kozmeticki_strucnjak_mbr,
                                         kozmeticki_strucnjak_mb );

CREATE TABLE obavlja_se (
    nudi_id_usl                   INTEGER NOT NULL,
    termin_id_t                   INTEGER NOT NULL,
    nudi_kozmeticki_strucnjak_mbr INTEGER NOT NULL,
    nudi_kozmeticki_strucnjak_mb  INTEGER NOT NULL,
    preparat_id_ko                INTEGER NOT NULL,
    kol_potr                      INTEGER
);

CREATE UNIQUE INDEX obavlja_se__idx ON
    obavlja_se (
        termin_id_t
    ASC );

ALTER TABLE obavlja_se
    ADD CONSTRAINT obavlja_se_pk PRIMARY KEY ( nudi_id_usl,
                                               nudi_kozmeticki_strucnjak_mbr,
                                               nudi_kozmeticki_strucnjak_mb,
                                               termin_id_t );

CREATE TABLE odrzava (
    serviser_mbr INTEGER NOT NULL,
    serviser_mb  INTEGER NOT NULL,
    aparat_id_ko INTEGER NOT NULL
);

ALTER TABLE odrzava
    ADD CONSTRAINT odrzava_pk PRIMARY KEY ( serviser_mbr,
                                            serviser_mb,
                                            aparat_id_ko );

CREATE TABLE preparat (
    id_ko  INTEGER NOT NULL,
    kol_ml INTEGER,
    rok    DATE
);

ALTER TABLE preparat ADD CONSTRAINT preparat_pk PRIMARY KEY ( id_ko );

CREATE TABLE pripada (
    racun_id_r             INTEGER NOT NULL,
    cenovnik_dat_p         DATE NOT NULL,
    cenovnik_usluga_id_usl INTEGER NOT NULL
);

ALTER TABLE pripada
    ADD CONSTRAINT pripada_pk PRIMARY KEY ( racun_id_r,
                                            cenovnik_dat_p,
                                            cenovnik_usluga_id_usl );

CREATE TABLE racun (
    id_r    INTEGER NOT NULL,
    dat_r   DATE NOT NULL,
    uk_cena FLOAT NOT NULL
);

ALTER TABLE racun ADD CONSTRAINT racun_pk PRIMARY KEY ( id_r );

CREATE TABLE radnik (
    mbr             INTEGER NOT NULL,
    ime_r           VARCHAR2(20) NOT NULL,
    prz_r           VARCHAR2(20) NOT NULL,
    tel_r           VARCHAR2(20),
    zan_r           VARCHAR2(20) NOT NULL,
    plt_r           FLOAT NOT NULL,
    salon_lepote_mb INTEGER NOT NULL
);

ALTER TABLE radnik
    ADD CONSTRAINT ch_inh_radnik CHECK ( zan_r IN ( 'Kozmeticki_strucnjak', 'Radnik', 'Recepcioner', 'Serviser' ) );

ALTER TABLE radnik ADD CONSTRAINT radnik_pk PRIMARY KEY ( mbr,
                                                          salon_lepote_mb );

CREATE TABLE raspored (
    id_rp INTEGER NOT NULL
);

ALTER TABLE raspored ADD CONSTRAINT raspored_pk PRIMARY KEY ( id_rp );

CREATE TABLE recepcioner (
    mbr INTEGER NOT NULL,
    mb  INTEGER NOT NULL
);

ALTER TABLE recepcioner ADD CONSTRAINT recepcioner_pk PRIMARY KEY ( mbr,
                                                                    mb );

CREATE TABLE salon_lepote (
    mb      INTEGER NOT NULL,
    pib     INTEGER NOT NULL,
    naziv_s VARCHAR2(20),
    adr_s   VARCHAR2(20)
);

ALTER TABLE salon_lepote ADD CONSTRAINT salon_lepote_pk PRIMARY KEY ( mb );

CREATE TABLE serviser (
    mbr INTEGER NOT NULL,
    mb  INTEGER NOT NULL
);

ALTER TABLE serviser ADD CONSTRAINT serviser_pk PRIMARY KEY ( mbr,
                                                              mb );

CREATE TABLE termin (
    id_t            INTEGER NOT NULL,
    usl_t           VARCHAR2(30) NOT NULL,
    dat_t           DATE NOT NULL,
    vreme_t         VARCHAR2(20) NOT NULL,
    recepcioner_mbr INTEGER NOT NULL,
    recepcioner_mb  INTEGER NOT NULL,
    raspored_id_rp  INTEGER NOT NULL,
    klijent_id_kl   INTEGER NOT NULL
);

ALTER TABLE termin ADD CONSTRAINT termin_pk PRIMARY KEY ( id_t );

CREATE TABLE usluga (
    id_usl  INTEGER NOT NULL,
    naz_usl VARCHAR2(30) NOT NULL
);

ALTER TABLE usluga ADD CONSTRAINT usluga_pk PRIMARY KEY ( id_usl );

ALTER TABLE aparat
    ADD CONSTRAINT aparat_kozmeticka_oprema_fk FOREIGN KEY ( id_ko )
        REFERENCES kozmeticka_oprema ( id_ko );

ALTER TABLE cenovnik
    ADD CONSTRAINT cenovnik_usluga_fk FOREIGN KEY ( usluga_id_usl )
        REFERENCES usluga ( id_usl );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE kozmeticka_oprema
    ADD CONSTRAINT kozmeticka_oprema_salon_lepote_fk FOREIGN KEY ( salon_lepote_mb )
        REFERENCES salon_lepote ( mb );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE kozmeticki_strucnjak
    ADD CONSTRAINT kozmeticki_strucnjak_kozmeticki_strucnjak_fk FOREIGN KEY ( edukator,
                                                                              mb )
        REFERENCES kozmeticki_strucnjak ( mbr,
                                          mb );

ALTER TABLE kozmeticki_strucnjak
    ADD CONSTRAINT kozmeticki_strucnjak_radnik_fk FOREIGN KEY ( mbr,
                                                                mb )
        REFERENCES radnik ( mbr,
                            salon_lepote_mb );

ALTER TABLE nudi
    ADD CONSTRAINT nudi_kozmeticki_strucnjak_fk FOREIGN KEY ( kozmeticki_strucnjak_mbr,
                                                              kozmeticki_strucnjak_mb )
        REFERENCES kozmeticki_strucnjak ( mbr,
                                          mb );

ALTER TABLE nudi
    ADD CONSTRAINT nudi_usluga_fk FOREIGN KEY ( usluga_id_usl )
        REFERENCES usluga ( id_usl );

ALTER TABLE obavlja_se
    ADD CONSTRAINT obavlja_se_nudi_fk FOREIGN KEY ( nudi_id_usl,
                                                    nudi_kozmeticki_strucnjak_mbr,
                                                    nudi_kozmeticki_strucnjak_mb )
        REFERENCES nudi ( usluga_id_usl,
                          kozmeticki_strucnjak_mbr,
                          kozmeticki_strucnjak_mb );

ALTER TABLE obavlja_se
    ADD CONSTRAINT obavlja_se_preparat_fk FOREIGN KEY ( preparat_id_ko )
        REFERENCES preparat ( id_ko );

ALTER TABLE obavlja_se
    ADD CONSTRAINT obavlja_se_termin_fk FOREIGN KEY ( termin_id_t )
        REFERENCES termin ( id_t );

ALTER TABLE odrzava
    ADD CONSTRAINT odrzava_aparat_fk FOREIGN KEY ( aparat_id_ko )
        REFERENCES aparat ( id_ko );

ALTER TABLE odrzava
    ADD CONSTRAINT odrzava_serviser_fk FOREIGN KEY ( serviser_mbr,
                                                     serviser_mb )
        REFERENCES serviser ( mbr,
                              mb );

ALTER TABLE preparat
    ADD CONSTRAINT preparat_kozmeticka_oprema_fk FOREIGN KEY ( id_ko )
        REFERENCES kozmeticka_oprema ( id_ko );

ALTER TABLE pripada
    ADD CONSTRAINT pripada_cenovnik_fk FOREIGN KEY ( cenovnik_dat_p,
                                                     cenovnik_usluga_id_usl )
        REFERENCES cenovnik ( dat_p,
                              usluga_id_usl );

ALTER TABLE pripada
    ADD CONSTRAINT pripada_racun_fk FOREIGN KEY ( racun_id_r )
        REFERENCES racun ( id_r );

ALTER TABLE radnik
    ADD CONSTRAINT radnik_salon_lepote_fk FOREIGN KEY ( salon_lepote_mb )
        REFERENCES salon_lepote ( mb );

ALTER TABLE recepcioner
    ADD CONSTRAINT recepcioner_radnik_fk FOREIGN KEY ( mbr,
                                                       mb )
        REFERENCES radnik ( mbr,
                            salon_lepote_mb );

ALTER TABLE serviser
    ADD CONSTRAINT serviser_radnik_fk FOREIGN KEY ( mbr,
                                                    mb )
        REFERENCES radnik ( mbr,
                            salon_lepote_mb );

ALTER TABLE termin
    ADD CONSTRAINT termin_klijent_fk FOREIGN KEY ( klijent_id_kl )
        REFERENCES klijent ( id_kl );

ALTER TABLE termin
    ADD CONSTRAINT termin_raspored_fk FOREIGN KEY ( raspored_id_rp )
        REFERENCES raspored ( id_rp );

ALTER TABLE termin
    ADD CONSTRAINT termin_recepcioner_fk FOREIGN KEY ( recepcioner_mbr,
                                                       recepcioner_mb )
        REFERENCES recepcioner ( mbr,
                                 mb );

CREATE OR REPLACE TRIGGER arc_fkarc_3_aparat BEFORE
    INSERT OR UPDATE OF id_ko ON aparat
    FOR EACH ROW
DECLARE
    d VARCHAR2(17);
BEGIN
    SELECT
        a.tip_ko
    INTO d
    FROM
        kozmeticka_oprema a
    WHERE
        a.id_ko = :new.id_ko;

    IF ( d IS NULL OR d <> 'Aparat' ) THEN
        raise_application_error(
                               -20223,
                               'FK Aparat_Kozmeticka_oprema_FK in Table Aparat violates Arc constraint on Table Kozmeticka_oprema - discriminator column TIP_KO doesn''t have value ''Aparat'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_fkarc_3_preparat BEFORE
    INSERT OR UPDATE OF id_ko ON preparat
    FOR EACH ROW
DECLARE
    d VARCHAR2(17);
BEGIN
    SELECT
        a.tip_ko
    INTO d
    FROM
        kozmeticka_oprema a
    WHERE
        a.id_ko = :new.id_ko;

    IF ( d IS NULL OR d <> 'Preparat' ) THEN
        raise_application_error(
                               -20223,
                               'FK Preparat_Kozmeticka_oprema_FK in Table Preparat violates Arc constraint on Table Kozmeticka_oprema - discriminator column TIP_KO doesn''t have value ''Preparat'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_fkarc_4_recepcioner BEFORE
    INSERT OR UPDATE OF mbr, mb ON recepcioner
    FOR EACH ROW
DECLARE
    d VARCHAR2(20);
BEGIN
    SELECT
        a.zan_r
    INTO d
    FROM
        radnik a
    WHERE
        a.mbr = :new.mbr
        AND a.salon_lepote_mb = :new.mb;

    IF ( d IS NULL OR d <> 'Recepcioner' ) THEN
        raise_application_error(
                               -20223,
                               'FK Recepcioner_Radnik_FK in Table Recepcioner violates Arc constraint on Table Radnik - discriminator column ZAN_R doesn''t have value ''Recepcioner'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_fkarc_4_serviser BEFORE
    INSERT OR UPDATE OF mbr, mb ON serviser
    FOR EACH ROW
DECLARE
    d VARCHAR2(20);
BEGIN
    SELECT
        a.zan_r
    INTO d
    FROM
        radnik a
    WHERE
        a.mbr = :new.mbr
        AND a.salon_lepote_mb = :new.mb;

    IF ( d IS NULL OR d <> 'Serviser' ) THEN
        raise_application_error(
                               -20223,
                               'FK Serviser_Radnik_FK in Table Serviser violates Arc constraint on Table Radnik - discriminator column ZAN_R doesn''t have value ''Serviser'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/

CREATE OR REPLACE TRIGGER arc_fkarc_kozmeticki_strucnjak BEFORE
    INSERT OR UPDATE OF mbr, mb ON kozmeticki_strucnjak
    FOR EACH ROW
DECLARE
    d VARCHAR2(20);
BEGIN
    SELECT
        a.zan_r
    INTO d
    FROM
        radnik a
    WHERE
        a.mbr = :new.mbr
        AND a.salon_lepote_mb = :new.mb;

    IF ( d IS NULL OR d <> 'Kozmeticki_strucnjak' ) THEN
        raise_application_error(
                               -20223,
                               'FK Kozmeticki_strucnjak_Radnik_FK in Table Kozmeticki_strucnjak violates Arc constraint on Table Radnik - discriminator column ZAN_R doesn''t have value ''Kozmeticki_strucnjak'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;
/





INSERT INTO SALON_LEPOTE (MB, PIB, NAZIV_S, ADR_S)
VALUES (1234, 1242, 'Glow and glitter', 'Dunavska 3');
INSERT INTO RADNIK (MBR, IME_R, PRZ_R, TEL_R,ZAN_R,PLT_R,SALON_LEPOTE_MB)
VALUES (1, 'Magdalena', 'Reljin','0612037939', 'Kozmeticki_strucnjak', 130000, 1234);
INSERT INTO RADNIK (MBR, IME_R, PRZ_R, TEL_R,ZAN_R,PLT_R,SALON_LEPOTE_MB)
VALUES (2, 'Dajana', 'Zlokapa','0612011939', 'Kozmeticki_strucnjak', 180000, 1234);
INSERT INTO RADNIK (MBR, IME_R, PRZ_R, TEL_R,ZAN_R,PLT_R,SALON_LEPOTE_MB)
VALUES (3, 'Tanja', 'Drcelic','0612037111', 'Kozmeticki_strucnjak', 160000, 1234);
INSERT INTO RADNIK (MBR, IME_R, PRZ_R, TEL_R,ZAN_R,PLT_R,SALON_LEPOTE_MB)
VALUES (4, 'Bojana', 'Cvjetojevic','0652037939', 'Kozmeticki_strucnjak', 120000, 1234);

INSERT INTO RADNIK (MBR, IME_R, PRZ_R, TEL_R,ZAN_R,PLT_R,SALON_LEPOTE_MB)
VALUES (5, 'Sonja', 'Dragas','0617777939', 'Recepcioner', 170000, 1234);
INSERT INTO RADNIK (MBR, IME_R, PRZ_R, TEL_R,ZAN_R,PLT_R,SALON_LEPOTE_MB)
VALUES (6, 'Dajana', 'Cvjetojevic','0612019876', 'Recepcioner', 130000, 1234);
INSERT INTO KOZMETICKI_STRUCNJAK (MBR, SERTIFIKAT, EDUKATOR, MB)
VALUES (1, 1, null,1234);
INSERT INTO KOZMETICKI_STRUCNJAK (MBR, SERTIFIKAT, EDUKATOR, MB)
VALUES (2, 1, 1,1234);
INSERT INTO KOZMETICKI_STRUCNJAK (MBR, SERTIFIKAT, EDUKATOR, MB)
VALUES (3, 1, 1,1234);
INSERT INTO KOZMETICKI_STRUCNJAK (MBR, SERTIFIKAT, EDUKATOR, MB)
VALUES (4, 0, null,1234);
INSERT INTO RECEPCIONER (MBR, MB)
VALUES (5, 1234);
INSERT INTO RECEPCIONER (MBR, MB)
VALUES (6, 1234);

INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (1, 'Higijenski tretman lica');
INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (2, 'Elektrostimulacija');
INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (3, 'Mikrodermoabrazija');
INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (5, 'Dijamantska mikrodermoabrazija');
INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (6, 'Ultrazvuk lica');
INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (7, 'Mesolift tretman');
INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (8, 'Radiotalasni lifting');
INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (9, 'Masaza lica');
INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (10, 'Piling lica');

INSERT INTO USLUGA (ID_USL, NAZ_USL)
VALUES (4, 'Oksigenacija');
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 3000,TO_DATE('2022-12-31','YYYY-MM-DD'),1);
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 700,TO_DATE('2022-12-31','YYYY-MM-DD'),2);
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 1500,TO_DATE('2022-12-31','YYYY-MM-DD'),3);
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 3700,TO_DATE('2022-12-31','YYYY-MM-DD'),4);
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 2000,TO_DATE('2022-12-31','YYYY-MM-DD'),5);
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 4300,TO_DATE('2022-12-31','YYYY-MM-DD'),6);
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 3500,TO_DATE('2022-12-31','YYYY-MM-DD'),7);
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 1000,TO_DATE('2022-12-31','YYYY-MM-DD'),8);
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 700,TO_DATE('2022-12-31','YYYY-MM-DD'),9);
INSERT INTO CENOVNIK (DAT_P, CENA_USL,DAT_Z,USLUGA_ID_USL)
VALUES (TO_DATE('2022-01-01','YYYY-MM-DD'), 5000,TO_DATE('2022-12-31','YYYY-MM-DD'),10);


INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (1, 1,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (2, 1,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (3, 1,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (4, 1,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (5, 1,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (1, 2,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (6, 2,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (7, 2,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (2, 3,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (8, 3,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (4, 4,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (9, 4,1234);
INSERT INTO NUDI (USLUGA_ID_USL, kozmeticki_strucnjak_mbr,kozmeticki_strucnjak_mb)
VALUES (10, 4,1234);

INSERT INTO RASPORED (ID_RP)
VALUES (1);

INSERT INTO KLIJENT (ID_KL,IME_KL,PRZ_KL,TEL_KL)
VALUES (1,'Natalija','Simin','068789365');
INSERT INTO KLIJENT (ID_KL,IME_KL,PRZ_KL,TEL_KL)
VALUES (2,'David','Jandric','068788865');
INSERT INTO KLIJENT (ID_KL,IME_KL,PRZ_KL,TEL_KL)
VALUES (3,'Kristina','Stojic','068776243');
INSERT INTO KLIJENT (ID_KL,IME_KL,PRZ_KL,TEL_KL)
VALUES (4,'Jelena','Hrnjak','068789365');
INSERT INTO KLIJENT (ID_KL,IME_KL,PRZ_KL,TEL_KL)
VALUES (5,'Marija','Jankovic','068788865');


INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (1,'Higijenski tretman',TO_DATE('2022-01-05','YYYY-MM-DD'),'08:00',5,1234,1,1);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (5,'Higijenski tretman',TO_DATE('2022-01-15','YYYY-MM-DD'),'08:00',6,1234,1,5);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (6,'Higijenski tretman',TO_DATE('2022-01-22','YYYY-MM-DD'),'08:00',5,1234,1,3);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (2,'Elektrostimulacija',TO_DATE('2022-01-07','YYYY-MM-DD'),'10:00',5,1234,1,2);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (3,'Mikrodermoabrazija',TO_DATE('2022-01-06','YYYY-MM-DD'),'11:00',5,1234,1,2);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (4,'Ultrazvuk lica',TO_DATE('2022-01-06','YYYY-MM-DD'),'11:00',5,1234,1,5);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (7,'Mesolift tretman',TO_DATE('2022-01-08','YYYY-MM-DD'),'11:00',6,1234,1,5);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (8,'Radiotalasni lifting',TO_DATE('2022-01-08','YYYY-MM-DD'),'11:00',6,1234,1,5);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (9,'Mesolift tretman',TO_DATE('2022-01-08','YYYY-MM-DD'),'15:00',6,1234,1,4);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (10,'Piling lica',TO_DATE('2022-01-08','YYYY-MM-DD'),'11:00',6,1234,1,4);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (11,'Piling lica',TO_DATE('2022-01-18','YYYY-MM-DD'),'11:00',6,1234,1,3);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (12,'Masaza lica',TO_DATE('2022-01-28','YYYY-MM-DD'),'18:00',6,1234,1,4);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (13,'Dijamantska mikrodermoabrazija',TO_DATE('2022-01-16','YYYY-MM-DD'),'19:00',5,1234,1,1);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (14,'Mesolift tretman',TO_DATE('2022-01-11','YYYY-MM-DD'),'15:00',6,1234,1,4);
INSERT INTO TERMIN (ID_T,USL_T,DAT_T,VREME_T,RECEPCIONER_MBR,RECEPCIONER_MB,RASPORED_ID_RP,KLIJENT_ID_KL)
VALUES (15,'Masaza lica',TO_DATE('2022-01-28','YYYY-MM-DD'),'09:00',6,1234,1,3);


INSERT INTO kozmeticka_oprema (id_ko,naz_ko,tip_ko,kol_ko,pro_ko,salon_lepote_mb)
VALUES (1,'Maska 1','Preparat',23,'Proizvodjac 1',1234);
INSERT INTO kozmeticka_oprema (id_ko,naz_ko,tip_ko,kol_ko,pro_ko,salon_lepote_mb)
VALUES (2,'Maska 2','Preparat',33,'Proizvodjac 2',1234);
INSERT INTO kozmeticka_oprema (id_ko,naz_ko,tip_ko,kol_ko,pro_ko,salon_lepote_mb)
VALUES (3,'Maska 3','Preparat',33,'Proizvodjac 3',1234);
INSERT INTO preparat (id_ko,kol_ml,rok)
VALUES (1,50,TO_DATE('2023-12-31','YYYY-MM-DD'));
INSERT INTO preparat (id_ko,kol_ml,rok)
VALUES (2,30,TO_DATE('2023-12-31','YYYY-MM-DD'));
INSERT INTO preparat (id_ko,kol_ml,rok)
VALUES (3,75,TO_DATE('2023-12-31','YYYY-MM-DD'));

INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (1,1,1,1234,1,1);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (1,5,1,1234,1,1);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (1,6,2,1234,1,1);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (2,2,3,1234,2,1);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (3,3,1,1234,3,3);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (6,4,2,1234,3,3);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (7,7,2,1234,1,3);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (7,9,2,1234,1,3);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (7,14,2,1234,1,3);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (8,8,3,1234,2,2);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (10,10,4,1234,1,2);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (10,11,4,1234,1,2);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (9,12,4,1234,1,1);
INSERT INTO OBAVLJA_SE (NUDI_ID_USL,termin_id_t,nudi_kozmeticki_strucnjak_mbr,nudi_kozmeticki_strucnjak_mb,preparat_id_ko,kol_potr)
VALUES (9,15,4,1234,1,1);
