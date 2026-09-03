"""
Gera dados sintéticos de e-commerce (clientes, produtos, lojas, vendas)
e salva em CSV dentro de ./data para posterior carga no Postgres.

Uso:
    python generate_data.py --clientes 2000 --produtos 300 --lojas 15 --vendas 50000
"""
import argparse
import os
import random
from datetime import date, timedelta

import pandas as pd
from faker import Faker

fake = Faker("pt_BR")
Faker.seed(42)
random.seed(42)

ESTADOS = ["SP", "RJ", "MG", "RS", "PR", "BA", "SC", "PE", "CE", "DF"]
SEGMENTOS = ["Varejo", "Atacado", "Premium", "Corporativo"]
CATEGORIAS = {
    "Eletrônicos": ["Celulares", "Notebooks", "Acessórios"],
    "Moda": ["Masculino", "Feminino", "Infantil"],
    "Casa": ["Móveis", "Decoração", "Cozinha"],
    "Esporte": ["Fitness", "Outdoor", "Ciclismo"],
    "Beleza": ["Perfumaria", "Cuidados com a Pele", "Maquiagem"],
}
MARCAS = ["Aurora", "Zenith", "Nortem", "Vivalta", "Kairo", "Bruma", "Solvex"]
FORMAS_PAGAMENTO = ["Cartão de Crédito", "Pix", "Boleto", "Cartão de Débito"]


def gerar_clientes(n):
    linhas = []
    for i in range(1, n + 1):
        linhas.append({
            "id_cliente": i,
            "nome": fake.name(),
            "email": fake.unique.email(),
            "cidade": fake.city(),
            "estado": random.choice(ESTADOS),
            "segmento": random.choice(SEGMENTOS),
            "data_cadastro": fake.date_between(start_date="-3y", end_date="-30d"),
        })
    return pd.DataFrame(linhas)


def gerar_produtos(n):
    linhas = []
    for i in range(1, n + 1):
        categoria = random.choice(list(CATEGORIAS.keys()))
        subcategoria = random.choice(CATEGORIAS[categoria])
        custo = round(random.uniform(10, 800), 2)
        margem = random.uniform(1.2, 2.5)
        linhas.append({
            "id_produto": i,
            "nome_produto": f"{subcategoria} {fake.word().capitalize()} {i}",
            "categoria": categoria,
            "subcategoria": subcategoria,
            "marca": random.choice(MARCAS),
            "preco_unitario": round(custo * margem, 2),
            "custo_unitario": custo,
        })
    return pd.DataFrame(linhas)


def gerar_lojas(n):
    linhas = []
    for i in range(1, n + 1):
        tipo = "ONLINE" if i <= max(1, n // 5) else "FISICA"
        linhas.append({
            "id_loja": i,
            "nome_loja": f"Loja {fake.city()}" if tipo == "FISICA" else f"Loja Online {i}",
            "cidade": fake.city(),
            "estado": random.choice(ESTADOS),
            "regiao": random.choice(["Sudeste", "Sul", "Nordeste", "Centro-Oeste", "Norte"]),
            "tipo_loja": tipo,
        })
    return pd.DataFrame(linhas)


def gerar_vendas(n, n_clientes, n_produtos, n_lojas, produtos_df):
    linhas = []
    data_inicio = date.today() - timedelta(days=365 * 2)
    preco_por_produto = produtos_df.set_index("id_produto")["preco_unitario"].to_dict()

    id_pedido_atual = 1
    itens_no_pedido = 0

    for i in range(1, n + 1):
        # agrupa vendas em "pedidos" (1 a 4 itens por pedido)
        if itens_no_pedido == 0:
            itens_no_pedido = random.randint(1, 4)
            id_pedido_atual += 1
        itens_no_pedido -= 1

        id_produto = random.randint(1, n_produtos)
        preco = preco_por_produto[id_produto]
        quantidade = random.randint(1, 5)
        desconto = round(preco * quantidade * random.choice([0, 0, 0, 0.05, 0.1, 0.15]), 2)
        dias_offset = random.randint(0, 365 * 2)

        linhas.append({
            "id_venda": i,
            "id_pedido": id_pedido_atual,
            "id_cliente": random.randint(1, n_clientes),
            "id_produto": id_produto,
            "id_loja": random.randint(1, n_lojas),
            "data_venda": data_inicio + timedelta(days=dias_offset),
            "quantidade": quantidade,
            "preco_unitario": preco,
            "valor_desconto": desconto,
            "forma_pagamento": random.choice(FORMAS_PAGAMENTO),
        })
    return pd.DataFrame(linhas)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--clientes", type=int, default=2000)
    parser.add_argument("--produtos", type=int, default=300)
    parser.add_argument("--lojas", type=int, default=15)
    parser.add_argument("--vendas", type=int, default=50000)
    parser.add_argument("--outdir", type=str, default="data")
    args = parser.parse_args()

    os.makedirs(args.outdir, exist_ok=True)

    print(f"Gerando {args.clientes} clientes...")
    clientes = gerar_clientes(args.clientes)
    clientes.to_csv(f"{args.outdir}/clientes.csv", index=False)

    print(f"Gerando {args.produtos} produtos...")
    produtos = gerar_produtos(args.produtos)
    produtos.to_csv(f"{args.outdir}/produtos.csv", index=False)

    print(f"Gerando {args.lojas} lojas...")
    lojas = gerar_lojas(args.lojas)
    lojas.to_csv(f"{args.outdir}/lojas.csv", index=False)

    print(f"Gerando {args.vendas} vendas...")
    vendas = gerar_vendas(args.vendas, args.clientes, args.produtos, args.lojas, produtos)
    vendas.to_csv(f"{args.outdir}/vendas.csv", index=False)

    print("Concluído. Arquivos salvos em:", os.path.abspath(args.outdir))


if __name__ == "__main__":
    main()
