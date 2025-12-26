/* SCRIPT 03: ANÁLISE DE EVASÃO 2023
   Objetivo: Identificar padrões regionais de desvinculação
   Qual estado brasileiro teve a maior proporção de alunos saindo dos cursos em 2024?
*/

SELECT 
    i.sg_uf AS estado, 
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
--- Análise por gratuidade, o fato do curso ser gratuito impacta na desistência?
SELECT 
    CASE WHEN i.in_gratuito = '1' THEN 'Gratuito (Público)' ELSE 'Pago (Privado)' END AS tipo_ies,
    ROUND(
        (SUM(c.qt_sit_desvinculado)::numeric / NULLIF(SUM(c.qt_mat), 0)) * 100, 
        2
    ) AS taxa_evasao_percentual
FROM cursos c
JOIN instituicoes i ON c.co_ies = i.co_ies
GROUP BY i.in_gratuito;

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
GROUP BY tp_modalidade_ensino
ORDER BY taxa_evasao_percentual DESC;
