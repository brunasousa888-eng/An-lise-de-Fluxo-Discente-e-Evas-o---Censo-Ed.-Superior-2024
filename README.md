# An-lise-de-Fluxo-Discente-e-Evas-o---Censo-Ed.-Superior-2024
Este projeto tem como objetivo analisar o fluxo discente no ensino superior brasileiro, com foco em evasão, permanência e conclusão de curso, a partir dos microdados do Censo da Educação Superior disponibilizados pelo INEP (Instituto Nacional de Estudos e Pesquisas Educacionais Anísio Teixeira).
Utilizando Structured Query Language (SQL) em ambiente PostgreSQL, o estudo busca identificar padrões associados ao tipo de instituição, perfil dos estudantes, grau acadêmico e distribuição geográfica, contribuindo para a compreensão de fenômenos educacionais relevantes para políticas públicas.

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

🧱 Estrutura do Projeto

├── dados/
│ └── amostra_censo_educacao_superior.csv
├── scripts/
│ ├── create_tables.sql
│ ├── limpeza.sql
│ └── consultas_analiticas.sql
├── docs/
│ └── diagrama_erd.png
└── README.md

🧠 Metodologia

1. Curadoria e Seleção de Variáveis
Redução de centenas de colunas para atributos essenciais relacionados ao fluxo discente (matrículas, evasão, conclusão, categoria administrativa, grau acadêmico, turno e UF).

2. Modelagem de Dados
Elaboração de um Diagrama Entidade-Relacionamento (ERD) com separação lógica entre Instituições de Ensino Superior (IES) e Cursos, evitando redundância e melhorando a integridade dos dados.
### 📊 Modelagem de Dados (ERD)

Abaixo, o Diagrama de Entidade-Relacionamento que ilustra a conexão entre as tabelas de Instituições e Cursos:

<div align="center">
  <img src="NOME_DA_SUA_PASTA/diagrama_er.png" alt="Diagrama de Entidade-Relacionamento" width="700px">
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

🔧 Em andamento
Banco estruturado e validado
Dados carregados na tabela bruta
Próxima etapa: consultas analíticas e geração de insights

📚 Referência

INEP. Microdados do Censo da Educação Superior.
Disponível em: https://www.gov.br/inep

✍️ Autoria:
Bruna Sousa
Projeto acadêmico em desenvolvimento com foco em análise de dados educacionais via SQL.
