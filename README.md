# Data Warehouse de E-commerce

Projeto de portfólio: um data warehouse analítico em **Star Schema**, construído com
**PostgreSQL + Docker + Python (geração/carga de dados) + dbt (transformação)**.

## Modelo dimensional

```
                 dim_tempo
                     |
  dim_cliente ---- fato_vendas ---- dim_produto
                     |
                 dim_loja
```

- **fato_vendas**: grão = 1 item de venda (quantidade, preço, desconto, valor_total, custo, margem)
- **dim_cliente**, **dim_produto**, **dim_loja**, **dim_tempo**: dimensões descritivas

## Estrutura do projeto

```
ecommerce-dw/
├── docker-compose.yml        # Postgres + pgAdmin
├── postgres/init.sql         # cria os schemas raw/staging/marts e as tabelas raw
├── python/
│   ├── generate_data.py      # gera dados sintéticos (Faker) em CSV
│   ├── load_data.py          # carrega os CSVs no schema raw do Postgres
│   └── requirements.txt
├── dbt/
│   ├── profiles.yml.example
│   └── ecommerce_dw/
│       ├── dbt_project.yml
│       └── models/
│           ├── staging/      # limpeza dos dados raw (views)
│           ├── marts/        # star schema: dimensões + fato (tables)
│           └── analytics/    # métricas prontas (receita mensal, RFM, ranking)
└── sql/consultas_analiticas.sql   # consultas SQL avançadas (window functions, ROLLUP, coorte)
```

## Como rodar (Windows / PowerShell)

**1. Subir o Postgres e o pgAdmin**
```powershell
docker compose up -d
```
pgAdmin fica disponível em `http://localhost:5050` (login: admin@admin.com / admin).

**2. Instalar dependências Python**
```powershell
cd python
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

**3. Gerar os dados sintéticos**
```powershell
python generate_data.py --clientes 2000 --produtos 300 --lojas 15 --vendas 50000
```

**4. Carregar os dados no Postgres (schema raw)**
```powershell
python load_data.py
```

**5. Instalar e rodar o dbt**
```powershell
cd ..\dbt\ecommerce_dw
pip install dbt-postgres
```
Copie `dbt\profiles.yml.example` para `C:\Users\<seu_usuario>\.dbt\profiles.yml`.
```powershell
dbt deps
dbt run
dbt test
dbt docs generate
dbt docs serve
```
Isso cria as views de staging, as dimensões e a fato em `marts.*`, e os modelos de
métricas em `analytics.*`.

**6. Rodar as consultas analíticas**
Abra o pgAdmin (http://localhost:5050), conecte no servidor Postgres (host: localhost, porta: 5433, usuário: dw_user, senha: dw_pass, banco: ecommerce_dw) e rode as consultas do arquivo `sql/consultas_analiticas.sql` — elas cobrem crescimento mês a mês, cubo OLAP com `ROLLUP`, participação percentual por categoria, análise de coorte de clientes, curva de Pareto e detecção de produtos em queda.

## Métricas de negócio já modeladas (schema `analytics`)

| Modelo | O que calcula |
|---|---|
| `metricas_vendas_mensal` | Receita, margem, itens vendidos, crescimento MoM e média móvel de 3 meses |
| `top_produtos_por_categoria` | Top 5 produtos por receita em cada categoria (RANK) |
| `rfm_clientes` | Segmentação RFM (Recência/Frequência/Valor) com NTILE, classificando clientes em Champions, Fiéis, Em Risco etc. |

## Notas técnicas

- Chaves substitutas (`sk_*`) são geradas com `dbt_utils.generate_surrogate_key`.
- `dim_tempo` é gerada com `dbt_utils.date_spine`, cobrindo 2022–2027.
- Testes de qualidade (`unique`, `not_null`, `relationships`, `accepted_values`,
  `accepted_range`) estão definidos nos arquivos `_staging.yml` e `_marts.yml`.
- O schema `raw` simula a camada de ingestão (dados brutos vindos do Python);
  `staging` e `marts` são inteiramente gerenciados pelo dbt.
