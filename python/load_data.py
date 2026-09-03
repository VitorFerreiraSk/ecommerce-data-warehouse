"""
Carrega os CSVs gerados em ./data para o schema `raw` no Postgres.

Uso:
    python load_data.py
Variáveis de ambiente (ou .env):
    DW_HOST, DW_PORT, DW_DB, DW_USER, DW_PASSWORD
"""
import os

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

load_dotenv()

DW_HOST = os.getenv("DW_HOST", "localhost")
DW_PORT = os.getenv("DW_PORT", "5433")
DW_DB = os.getenv("DW_DB", "ecommerce_dw")
DW_USER = os.getenv("DW_USER", "dw_user")
DW_PASSWORD = os.getenv("DW_PASSWORD", "dw_pass")

TABELAS = {
    "clientes": "data/clientes.csv",
    "produtos": "data/produtos.csv",
    "lojas": "data/lojas.csv",
    "vendas": "data/vendas.csv",
}

COLUNAS_DATA = {
    "clientes": ["data_cadastro"],
    "vendas": ["data_venda"],
}


def main():
    url = f"postgresql+psycopg://{DW_USER}:{DW_PASSWORD}@{DW_HOST}:{DW_PORT}/{DW_DB}"
    engine = create_engine(url)

    with engine.begin() as conn:
        # ordem importa por causa das foreign keys
        for tabela in ["vendas", "clientes", "produtos", "lojas"]:
            conn.execute(text(f"TRUNCATE TABLE raw.{tabela} CASCADE"))

        for tabela, caminho in [
            ("clientes", TABELAS["clientes"]),
            ("produtos", TABELAS["produtos"]),
            ("lojas", TABELAS["lojas"]),
            ("vendas", TABELAS["vendas"]),
        ]:
            print(f"Carregando {caminho} -> raw.{tabela} ...")
            df = pd.read_csv(caminho, parse_dates=COLUNAS_DATA.get(tabela, []))
            df.to_sql(tabela, con=conn, schema="raw", if_exists="append", index=False)
            print(f"  {len(df)} linhas carregadas.")

    print("Carga concluída com sucesso.")


if __name__ == "__main__":
    main()
