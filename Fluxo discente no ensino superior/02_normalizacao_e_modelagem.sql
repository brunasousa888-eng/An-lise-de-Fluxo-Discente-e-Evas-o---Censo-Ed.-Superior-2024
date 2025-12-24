DROP TABLE IF EXISTS fluxo_discente_bruto;

CREATE TABLE fluxo_discente_bruto (
    NO_REGIAO TEXT,
    QT_CURSO TEXT,
    QT_VG_TOTAL TEXT,
    QT_VG_TOTAL_DIURNO TEXT,
    QT_VG_TOTAL_NOTURNO TEXT,
    QT_VG_TOTAL_EAD TEXT,
    QT_ING TEXT,
    QT_ING_FEM TEXT,
    QT_ING_MASC TEXT,
    QT_ING_DIURNO TEXT,
    QT_ING_NOTURNO TEXT,
    QT_ING_BRANCA TEXT,
    QT_ING_PRETA TEXT,
    QT_ING_PARDA TEXT,
    QT_ING_AMARELA TEXT,
    QT_ING_INDIGENA TEXT,
    QT_MAT TEXT,
    QT_MAT_FEM TEXT,
    QT_MAT_MASC TEXT,
    QT_MAT_DIURNO TEXT,
    QT_MAT_NOTURNO TEXT,
    QT_MAT_BRANCA TEXT,
    QT_MAT_PRETA TEXT,
    QT_MAT_PARDA TEXT,
    QT_MAT_AMARELA TEXT,
    QT_MAT_INDIGENA TEXT,
    QT_CONC TEXT,
    QT_CONC_FEM TEXT,
    QT_CONC_MASC TEXT,
    QT_CONC_DIURNO TEXT,
    QT_CONC_NOTURNO TEXT,
    QT_CONC_BRANCA TEXT,
    QT_CONC_PRETA TEXT,
    QT_CONC_PARDA TEXT,
    QT_CONC_AMARELA TEXT,
    QT_CONC_INDIGENA TEXT,
    QT_SIT_TRANCADA TEXT,
    QT_SIT_DESVINCULADO TEXT,
    QT_SIT_TRANSFERIDO TEXT,
    QT_SIT_FALECIDO TEXT,
    NO_CURSO_ORIGINAL TEXT, -- Coluna 41 do seu arquivo
    TP_ORGANIZACAO_ACADEMICA TEXT,
    TP_REDE TEXT,
    TP_CATEGORIA_ADMINISTRATIVA TEXT,
    TP_GRAU_ACADEMICO TEXT,
    TP_MODALIDADE_ENSINO TEXT,
    TP_NIVEL_ACADEMICO TEXT,
    QT_INSCRITO_TOTAL TEXT,
    QT_INSCRITO_TOTAL_DIURNO TEXT,
    QT_INSCRITO_TOTAL_NOTURNO TEXT,
    QT_INSCRITO_TOTAL_EAD TEXT,
    SG_UF TEXT,
    NU_ANO_CENSO TEXT,
    CO_IES TEXT,
    NO_CURSO_REPETIDO TEXT, -- O arquivo tem NO_CURSO duas vezes
    CO_CURSO TEXT,
    IN_GRATUITO TEXT
);

DROP TABLE IF EXISTS fluxo_discente_bruto;

CREATE TABLE fluxo_discente_bruto (
    no_regiao TEXT,
    qt_curso TEXT,
    qt_vg_total TEXT,
    qt_vg_total_diurno TEXT,
    qt_vg_total_noturno TEXT,
    qt_vg_total_ead TEXT,
    qt_ing TEXT,
    qt_ing_fem TEXT,
    qt_ing_masc TEXT,
    qt_ing_diurno TEXT,
    qt_ing_noturno TEXT,
    qt_ing_branca TEXT,
    qt_ing_preta TEXT,
    qt_ing_parda TEXT,
    qt_ing_amarela TEXT,
    qt_ing_indigena TEXT,
    qt_mat TEXT,
    qt_mat_fem TEXT,
    qt_mat_masc TEXT,
    qt_mat_diurno TEXT,
    qt_mat_noturno TEXT,
    qt_mat_branca TEXT,
    qt_mat_preta TEXT,
    qt_mat_parda TEXT,
    qt_mat_amarela TEXT,
    qt_mat_indigena TEXT,
    qt_conc TEXT,
    qt_conc_fem TEXT,
    qt_conc_masc TEXT,
    qt_conc_diurno TEXT,
    qt_conc_noturno TEXT,
    qt_conc_branca TEXT,
    qt_conc_preta TEXT,
    qt_conc_parda TEXT,
    qt_conc_amarela TEXT,
    qt_conc_indigena TEXT,
    qt_sit_trancada TEXT,
    qt_sit_desvinculado TEXT,
    qt_sit_transferido TEXT,
    qt_sit_falecido TEXT,
    no_curso TEXT,            -- ONDE ESTÁ DANDO ERRO (NOME LONGO)
    tp_organizacao_academica TEXT,
    tp_rede TEXT,
    tp_categoria_administrative TEXT,
    tp_grau_academico TEXT,
    tp_modalidade_ensino TEXT,
    tp_nivel_academico TEXT,
    qt_inscrito_total TEXT,
    qt_inscrito_total_diurno TEXT,
    qt_inscrito_total_noturno TEXT,
    qt_inscrito_total_ead TEXT,
    sg_uf TEXT,
    nu_ano_censo TEXT,
    co_ies TEXT,
    no_curso_1 TEXT,          -- ONDE ESTÁ DANDO ERRO (NOME LONGO REPETIDO)
    co_curso TEXT,
    in_gratuito TEXT
);


CREATE TABLE instituicoes AS
SELECT DISTINCT 
    co_ies::INTEGER, 
    sg_uf, 
    NULLIF(in_gratuito, '')::INTEGER AS in_gratuito
FROM fluxo_discente_bruto;

-- Define a Chave Primária

-- 1. Remove a tabela antiga se ela existir para evitar o erro 42P07
DROP TABLE IF EXISTS cursos; -- Remova os cursos primeiro por causa do relacionamento
DROP TABLE IF EXISTS instituicoes;

-- 2. Agora sim, cria a tabela de Instituições novamente
CREATE TABLE instituicoes AS
SELECT DISTINCT 
    co_ies::INTEGER, 
    sg_uf, 
    NULLIF(in_gratuito, '')::INTEGER AS in_gratuito
FROM fluxo_discente_bruto;

-- 3. Define a Chave Primária
ALTER TABLE instituicoes ADD PRIMARY KEY (co_ies);

-- 4. Cria a tabela de Cursos
CREATE TABLE cursos AS
SELECT 
    co_curso::INTEGER,
    no_curso,
    co_ies::INTEGER,
    NULLIF(qt_vg_total, '')::INTEGER AS qt_vg_total,
    NULLIF(qt_mat, '')::INTEGER AS qt_mat,
    NULLIF(qt_conc, '')::INTEGER AS qt_conc,
    NULLIF(qt_sit_desvinculado, '')::INTEGER AS qt_sit_desvinculado
FROM fluxo_discente_bruto;

-- 5. Define o relacionamento
ALTER TABLE cursos 
ADD CONSTRAINT fk_ies_curso 
FOREIGN KEY (co_ies) REFERENCES instituicoes (co_ies);

-- 1. Limpa as tentativas anteriores
DROP TABLE IF EXISTS cursos;
DROP TABLE IF EXISTS instituicoes;

-- 2. Cria a tabela de Instituições garantindo UNICIDADE pelo co_ies
CREATE TABLE instituicoes AS
SELECT 
    co_ies::INTEGER, 
    MAX(sg_uf) as sg_uf, -- Pega uma UF (evita duplicatas por erro de digitação)
    MAX(NULLIF(in_gratuito, '')::INTEGER) AS in_gratuito -- Pega o valor máximo (1 ou 0)
FROM fluxo_discente_bruto
GROUP BY co_ies; -- O segredo está aqui: Agrupa tudo pelo código da faculdade

-- 3. Agora a Chave Primária vai funcionar perfeitamente
ALTER TABLE instituicoes ADD PRIMARY KEY (co_ies);

-- 4. Cria a tabela de Cursos (esta não costuma dar erro de duplicata no ID do curso)
CREATE TABLE cursos AS
SELECT 
    co_curso::INTEGER,
    no_curso,
    co_ies::INTEGER,
    NULLIF(qt_vg_total, '')::INTEGER AS qt_vg_total,
    NULLIF(qt_mat, '')::INTEGER AS qt_mat,
    NULLIF(qt_conc, '')::INTEGER AS qt_conc,
    NULLIF(qt_sit_desvinculado, '')::INTEGER AS qt_sit_desvinculado
FROM fluxo_discente_bruto;

-- 5. Cria o relacionamento entre elas
ALTER TABLE cursos 
ADD CONSTRAINT fk_ies_curso 
FOREIGN KEY (co_ies) REFERENCES instituicoes (co_ies);

select * from instituicoes limit 10

SELECT count(*), co_ies 
FROM instituicoes 
GROUP BY co_ies 
HAVING count(*) > 1;

-- 1. Remove a tabela de cursos se ela já existir para evitar erro
DROP TABLE IF EXISTS cursos;

-- 2. Cria a tabela de Cursos convertendo os textos para números
CREATE TABLE cursos AS
SELECT 
    co_curso::INTEGER,
    no_curso,
    co_ies::INTEGER,
    NULLIF(qt_vg_total, '')::INTEGER AS qt_vg_total,
    NULLIF(qt_mat, '')::INTEGER AS qt_mat,
    NULLIF(qt_conc, '')::INTEGER AS qt_conc,
    NULLIF(qt_sit_desvinculado, '')::INTEGER AS qt_sit_desvinculado
FROM fluxo_discente_bruto;

-- 3. Cria o Relacionamento (A Ponte)
-- Isso garante que todo CO_IES na tabela cursos exista na tabela instituicoes
ALTER TABLE cursos 
ADD CONSTRAINT fk_ies_curso 
FOREIGN KEY (co_ies) REFERENCES instituicoes (co_ies);

SELECT 
    i.sg_uf, 
    c.no_curso, 
    c.qt_mat
FROM cursos c
JOIN instituicoes i ON c.co_ies = i.co_ies
LIMIT 10;

ALTER TABLE cursos 
ADD CONSTRAINT fk_ies_curso 
FOREIGN KEY (co_ies) REFERENCES instituicoes (co_ies);