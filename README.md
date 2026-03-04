# 📑 Northwind Analytics DBT Project

Este repositório é a evolução natural do meu projeto anterior, o [Northwind-SQL-Analytics](https://github.com/IagoTannusb/Northwind-SQL-Analytics). 

Enquanto o primeiro projeto focava em extrair insights através de scripts SQL puros, este repositório recria e expande essas análises utilizando o **DBT (data build tool)**. O objetivo principal aqui não é apenas responder perguntas de negócio, mas sim construir um pipeline de dados robusto, testável e modular.

## Por que usar o dbt em vez de SQL puro?

No projeto anterior, as queries SQL eram excelentes para análise, mas apresentavam desafios comuns em ambientes de produção:
1. **Falta de Modularidade (DRY - Don't Repeat Yourself):** Lógicas comuns (como cálculo de faturamento ou limpeza de strings) precisavam ser repetidas em vários scripts.
2. **Dependências Invisíveis:** Era difícil saber qual query precisava rodar antes da outra (Lineage/DAG).
3. **Qualidade de Dados:** Não havia validação automática para garantir que não existiam IDs duplicados, valores nulos ou chaves estrangeiras quebradas.
4. **Governança e Documentação:** A documentação ficava separada do código.

O dbt permite escrever transformações em SQL de forma modular (com Jinja), testa os dados automaticamente e gera a documentação e a linhagem de dados (DAG) direto do código, resolvendo assim todos os problemas descritos. 

---

## Visão Geral

Este projeto transforma dados brutos do banco de dados **Northwind** em modelos analíticos prontos para BI, utilizando as melhores práticas de Engenharia de Dados. 

O pipeline processa dados de vendas, clientes e produtos, organizando-os em camadas (Staging, Intermediate e Marts) para fornecer métricas críticas como:

- **Vendas Acumuladas Diárias:** Evolução temporal da receita.
- **Performance de Produtos:** Preços unitários e quantidades vendidas.
- **Qualidade de Dados:** Garantia de integridade através de testes automatizados.

### Arquitetura e Fluxo de Dados

O projeto utiliza a arquitetura modular recomendada pelo dbt, dividida em três camadas principais:

1. **Staging (`stg_`)**: Aqui é feito o "casting" de tipos, renomeação de colunas para um padrão consistente e limpezas básicas. É o único lugar que toca as tabelas brutas do banco.
2. **Intermediate (`int_`)**: Nesta camada, fazemos os joins diferentes fontes de staging e aplicamos transformações complexas que não são específicas de um único dashboard, mas que preparam o dado para múltiplos usos.
   - *Exemplo:* Unir `stg_orders` com `stg_order_details` para criar uma visão única de itens de pedido antes de agregar valores.
3. **Marts (`fct_` / `dim_`)**: É a camada final de consumo. Aqui os dados são organizados em modelos de Fato e Dimensão, prontos para ferramentas de BI. É onde é aplicado as **Window Functions** para calcular os acumulados diários.

## Instalação e Execução

### Pré-requisitos

- Docker e Docker Compose
- Python 3.12+ (recomendado usar `uv` para gestão de pacotes)

### Passos

1. **Subir o Banco de Dados:**
    ```bash
    docker compose up -d
    ```
2. **Instalar Dependências:**
    ```bash
    uv sync
    ```
3. **Validar a conexão:**
    - Garante que o dbt está conseguindo se comunicar com o banco de dados local
    ```bash
    uv run dbt debug
    ```
4. **Executar o pipeline DBT:**
    ```bash
    uv run dbt run
    ```

## Qualidade e Testes de Dados

A confiabilidade é o foco deste projeto. Foi implementado Testes Singulares para capturar anomalias de negócio:

    - Integridade Financeira: Os descontos devem estar entre 0 e 100% e a receita líquida nunca pode exceder a bruta.

    - Lógica Temporal: A data de envio (shipped_date) deve ser posterior à data do pedido.

    - Consistência de Estoque: As quantidades vendidas devem ser sempre positivas.

## Simulação de falhas

O projeto inclui tambéem um script teste_falha.py que injeta dados corrompidos intencionalmente no banco para validar a eficácia dos alertas do dbt.
    ```bash
    uv run python chaos_script.py
    uv run dbt test # Verificar os alertas vermelhos
    ```
## Documentação Automática do dbt  
    ```bash
    uv run dbt docs generate
    uv run dbt docs serve
    ```