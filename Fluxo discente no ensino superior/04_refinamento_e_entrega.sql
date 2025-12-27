---------------------------------------------------------
-- CAMADA DE REFINAMENTO (VIEWS E QUALIDADE)
---------------------------------------------------------
-- Aqui entram as Views (vw_evasao_modalidade, vw_evasao_gratuidade)
-- E os testes de sanidade (Cursos zerados, etc)
-- 1. View de Evasão por Modalidade (EAD vs Presencial)
-- Esta busca na bruta pois a modalidade não foi para a tabela cursos
CREATE OR REPLACE VIEW vw_evasao_modalidade AS
SELECT 
    CASE 
        WHEN tp_modalidade_ensino = '1' THEN 'Presencial' 
        WHEN tp_modalidade_ensino = '2' THEN 'EAD' 
        ELSE 'Não Informado' 
    END AS modalidade,
    SUM(qt_mat::integer) AS total_matriculas,
    ROUND(
        (SUM(qt_sit_desvinculado::integer)::numeric / NULLIF(SUM(qt_mat::integer), 0)) * 100, 
        2
    ) AS taxa_evasao_percentual
FROM fluxo_discente_bruto
GROUP BY tp_modalidade_ensino;

-- 2. View de Evasão por Tipo de Instituição (Baseada na sua tabela Cursos)
CREATE OR REPLACE VIEW vw_evasao_gratuidade AS
SELECT 
    CASE WHEN i.in_gratuito = '1' THEN 'Gratuito (Público)' ELSE 'Pago (Privado)' END AS tipo_ies,
    SUM(c.qt_mat) AS total_matriculas,
    ROUND(
        (SUM(c.qt_sit_desvinculado)::numeric / NULLIF(SUM(c.qt_mat), 0)) * 100, 
        2
    ) AS taxa_evasao_percentual
FROM cursos c
JOIN instituicoes i ON c.co_ies = i.co_ies
GROUP BY i.in_gratuito;

CREATE OR REPLACE VIEW vw_evasao_gratuidade AS
SELECT 
    CASE WHEN i.in_gratuito = '1' THEN 'Gratuito (Público)' ELSE 'Pago (Privado)' END AS tipo_ies,
    SUM(c.qt_mat) AS total_matriculas,
    SUM(c.qt_sit_desvinculado) AS total_desistencias,
    ROUND(
        (SUM(c.qt_sit_desvinculado)::numeric / NULLIF(SUM(c.qt_mat), 0)) * 100, 
        2
    ) AS taxa_evasao_percentual
FROM cursos c
JOIN instituicoes i ON c.co_ies = i.co_ies
GROUP BY i.in_gratuito;

-- 1. Deleta a versão antiga que está travando a alteração
DROP VIEW IF EXISTS vw_evasao_gratuidade;

-- 2. Cria a versão nova com a estrutura de colunas correta
CREATE VIEW vw_evasao_gratuidade AS
SELECT 
    CASE WHEN i.in_gratuito = '1' THEN 'Gratuito (Público)' ELSE 'Pago (Privado)' END AS tipo_ies,
    SUM(c.qt_mat) AS total_matriculas,
    SUM(c.qt_sit_desvinculado) AS total_desistencias,
    ROUND(
        (SUM(c.qt_sit_desvinculado)::numeric / NULLIF(SUM(c.qt_mat), 0)) * 100, 
        2
    ) AS taxa_evasao_percentual
FROM cursos c
JOIN instituicoes i ON c.co_ies = i.co_ies
GROUP BY i.in_gratuito;
SELECT * FROM vw_evasao_gratuidade;

-- TESTE 1: Verificar se há registros onde a evasão é maior que a matrícula (Impossível na vida real)
SELECT co_ies, no_curso, qt_mat, qt_sit_desvinculado
FROM cursos
WHERE qt_sit_desvinculado > qt_mat;

-- TESTE 2: Verificar se há cursos sem nenhuma matrícula vinculada (Dados fantasma)
SELECT COUNT(*) AS cursos_zerados 
FROM cursos 
WHERE qt_mat = 0;

CREATE OR REPLACE VIEW vw_cursos_ativos AS
SELECT * FROM cursos 
WHERE qt_mat > 0;

-- View de Evasão por Estado (UF)
CREATE OR REPLACE VIEW vw_evasao_estado AS
SELECT 
    SG_UF AS estado,
    SUM(qt_mat) AS total_matriculas,
    SUM(qt_sit_desvinculado) AS total_desistencias,
    ROUND(
        (SUM(qt_sit_desvinculado)::numeric / NULLIF(SUM(qt_mat), 0)) * 100, 
        2
    ) AS taxa_evasao_percentual
FROM cursos
GROUP BY SG_UF
ORDER BY taxa_evasao_percentual DESC;

SELECT * FROM cursos LIMIT 1;

CREATE OR REPLACE VIEW vw_evasao_estado AS
SELECT 
    i.sg_uf AS estado, -- Se der erro, tente i.co_uf
    SUM(c.qt_mat) AS total_matriculas,
    SUM(c.qt_sit_desvinculado) AS total_desistencias,
    ROUND(
        (SUM(c.qt_sit_desvinculado)::numeric / NULLIF(SUM(c.qt_mat), 0)) * 100, 
        2
    ) AS taxa_evasao_percentual
FROM cursos c
JOIN instituicoes i ON c.co_ies = i.co_ies
GROUP BY i.sg_uf
ORDER BY taxa_evasao_percentual DESC;

-- View de Evasão por Curso
CREATE OR REPLACE VIEW vw_evasao_curso AS
SELECT 
    no_curso AS nome_curso,
    SUM(qt_mat) AS total_matriculas,
    SUM(qt_sit_desvinculado) AS total_desistencias,
    ROUND(
        (SUM(qt_sit_desvinculado)::numeric / NULLIF(SUM(qt_mat), 0)), 
        4
    ) AS taxa_evasao_decimal -- Deixando em decimal para o Power BI formatar
FROM cursos
WHERE qt_mat > 50 -- Filtro de relevância: ignora cursos muito pequenos
GROUP BY no_curso
ORDER BY taxa_evasao_decimal DESC;