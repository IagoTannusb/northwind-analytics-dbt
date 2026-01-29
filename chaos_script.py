import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        port="55432",
        database="northwind",
        user="postgres",
        password="postgres"
    )
    cur = conn.cursor()

    print("😈 Iniciando a sabotagem via UPDATE no banco Northwind...")

    # 1. Sabotando: Quantidade negativa (-10) e Desconto de 250% (2.5)
    cur.execute("""
        UPDATE public.order_details 
        SET quantity = -10, discount = 2.5
        WHERE order_id = 10248 AND product_id = 11;
    """)

    # 2. Sabotando: Data de envio em 1990 (antes da criação da empresa)
    cur.execute("""
        UPDATE public.orders 
        SET shipped_date = '1990-01-01' 
        WHERE order_id = 10249;
    """)

    conn.commit()
    print("✅ Sabotagem concluída com sucesso! Agora o dbt vai detectar os erros.")

except Exception as e:
    print(f"❌ Erro ao sabotar: {e}")

finally:
    if 'cur' in locals(): cur.close()
    if 'conn' in locals(): conn.close()