# 📑 Northwind Analytics DBT Project

Este projeto transforma dados brutos do banco de dados **Northwind** em modelos analíticos prontos para Business Intelligence, utilizando as melhores práticas de Engenharia de Dados com **dbt (data build tool)**.

## Visão Geral

O pipeline processa dados de vendas, clientes e produtos, organizando-os em camadas (Staging, Intermediate e Marts) para fornecer métricas críticas como:

- **Vendas Acumuladas Diárias:** Evolução temporal da receita.
- **Performance de Produtos:** Preços unitários e quantidades vendidas.
- **Qualidade de Dados:** Garantia de integridade através de testes automatizados.
    

### Arquitetura e Fluxo de Dados

O projeto utiliza a arquitetura modular recomendada pelo dbt, dividida em três camadas principais:

1. **Staging (`stg_`)**: Aqui fazemos o "casting" de tipos, renomeação de colunas para um padrão consistente e limpezas básicas. É o único lugar que toca as tabelas brutas do banco.
2. **Intermediate (`int_`)**: Nesta camada, unimos (`joins`) diferentes fontes de staging e aplicamos transformações complexas que não são específicas de um único dashboard, mas que preparam o dado para múltiplos usos.
    - _Exemplo:_ Unir `stg_orders` com `stg_order_details` para criar uma visão única de itens de pedido antes de agregar valores.
3. **Marts (`fct_` / `dim_`)**: É a camada final de consumo. Aqui os dados são organizados em modelos de Fato e Dimensão, prontos para ferramentas de BI. É onde aplicamos as **Window Functions** para calcular os acumulados diários.
    

## Instalação e Execução
### Pré-requisitos

- Docker e Docker Compose
- Python 3.12+ (recomendado usar `uv` para gestão de pacotes)
    
### Passos
1. **Subir o Banco de Dados:**
    
    
    ```Bash
    docker compose up -d
    ```
    
2. **Instalar Dependências:**
    
    
    ```Bash
    uv sync
    ```
    
3. **Executar o Pipeline dbt:**
    
    
    ```Bash
    uv run dbt run
    ```
    

## 🧪 Qualidade e Testes de Dados

A confiabilidade é o coração deste projeto. Implementamos **Testes Singulares** para capturar anomalias de negócio:

- **Integridade Financeira:** Descontos devem estar entre 0 e 100%; Receita líquida nunca pode exceder a bruta.
- **Lógica Temporal:** A data de envio (`shipped_date`) deve ser posterior à data do pedido.
- **Consistência de Estoque:** Quantidades vendidas devem ser sempre positivas.
    

### Simulação de Falhas (Chaos Testing)

Incluímos um script `chaos_script.py` que injeta dados corrompidos intencionalmente para validar a eficácia dos alertas do dbt.



```Bash
uv run python chaos_script.py
uv run dbt test # Verifique os alertas vermelhos!
```

## 📈 Documentação Automática
Para visualizar o dicionário de dados e a linhagem completa:

Bash
```
uv run dbt docs generate
uv run dbt docs serve
```
---
