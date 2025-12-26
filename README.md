# An-lise-de-Fluxo-Discente-e-Evas-o---Censo-Ed.-Superior-2024
Este projeto analisa o fluxo discente no ensino superior brasileiro utilizando SQL e PostgreSQL. O estudo identifica padrões de evasão, permanência e conclusão a partir dos microdados do Censo da Educação Superior 2024 (INEP).

📊 Principais Descobertas (Insights)
Os dados revelam indicadores críticos sobre a retenção de estudantes no Brasil:

Fator Econômico: A taxa de evasão em instituições Pagas (39,28%) é quase 2,5 vezes superior à de instituições Gratuitas (15,96%).

Impacto da Modalidade: O ensino EAD apresenta uma taxa de desvinculação de 49,07%, evidenciando um desafio de retenção muito maior que o ensino Presencial (19,82%).

Gargalos Regionais: Estados como Tocantins (TO), Amazonas (AM) e Santa Catarina (SC) lideram os índices de desvinculação regional.

Qualidade dos Dados: Foi identificado 163.941 registros de cursos sem matrículas ativas no ciclo, que foram isolados para garantir a precisão da análise final.
🎯 Objetivos da Análise

Medir a taxa de evasão e permanência no ensino superior brasileiro
Comparar a evasão entre instituições públicas e privadas
Identificar o perfil etário e o turno predominante entre alunos evadidos
Analisar diferenças de evasão entre cursos de Licenciatura e Bacharelado
Mapear as Unidades da Federação com maiores taxas de conclusão de curso

🗂️ Base de Dados

Fonte: Censo da Educação Superior – INEP
Ano: 2024
Formato original: CSV (delimitado por ;)
Documentação: Dicionário de Dados oficial do INEP

📌 Para viabilizar o processamento, foi utilizada uma amostra filtrada dos microdados, mantendo apenas as variáveis relevantes para o escopo do projeto.

🧱 Estrutura do Projeto (Pipeline de Dados)
O repositório está organizado seguindo as melhores práticas de Engenharia de Dados:

01_carga_bruta.sql: Ingestão dos microdados via comandos COPY e criação da camada de staging.

02_limpeza_e_modelagem.sql: Normalização das tabelas de IES e Cursos, tratamento de tipos de dados e aplicação de integridade referencial.

03_analise_e_insights.sql: Consultas analíticas exploratórias (Geográfica, Administrativa e por Modalidade).

04_refinamento_e_entrega.sql: Criação de Views Analíticas (Camada Semântica) e scripts de Data Quality para validação de sanidade dos dados.

🛠️ Evolução Técnica e Diferenciais
Modelagem Relacional: Separação lógica entre Entidades (IES) e Fatos (Cursos/Fluxo) para otimização de performance.

Camada de Entrega: Implementação de Views otimizadas para consumo direto por ferramentas de BI (Power BI/Tableau).

Rigor Analítico: Tratamento de erros de divisão por zero (NULLIF) e filtragem de "cursos fantasmas" para evitar distorções estatísticas.

🧠 Metodologia

1. Curadoria e Seleção de Variáveis
Redução de centenas de colunas para atributos essenciais relacionados ao fluxo discente (matrículas, evasão, conclusão, categoria administrativa, grau acadêmico, turno e UF).

2. Modelagem de Dados
Elaboração de um Diagrama Entidade-Relacionamento (ERD) com separação lógica entre Instituições de Ensino Superior (IES) e Cursos, evitando redundância e melhorando a integridade dos dados.
### 📊 Modelagem de Dados (ERD)

Abaixo, o Diagrama de Entidade-Relacionamento que ilustra a conexão entre as tabelas de Instituições e Cursos:

<div align="center">
  <img src="Fluxo discente no ensino superior/Diagrama de Entidade-Relacionamento do Fluxo Discente.png" alt="Diagrama de Entidade-Relacionamento" width="700px">
</div>
3. Infraestrutura

Banco de dados: PostgreSQL (Supabase – nuvem)
Ferramenta de gerenciamento: DBeaver
4. Importação e Tratamento
Criação de uma staging table (fluxo_discente_bruto) com tipagem inicial em TEXT
Ajustes de delimitador (;)
Preparação para normalização e análises posteriores
🧪 Tecnologias Utilizadas
PostgreSQL
DBeaver
Supabase
SQL
dbdiagram.io (modelagem)
Microsoft Excel (tratamento inicial)

📈 Status do Projeto

🔧 Concluído
Banco estruturado e validado
Dados carregados na tabela bruta
Insights gerados e documentados.

📚 Referência

INEP. Microdados do Censo da Educação Superior.
Disponível em: https://www.gov.br/inep

✍️ Autoria:
Bruna Santana
Projeto acadêmico com foco em análise de dados educacionais via SQL.
