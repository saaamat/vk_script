import psycopg2
import requests
from psycopg2.extras import Json
import vk_api
from time import sleep


def get_vk_user_info(user_id, access_token):
    url = 'https://api.vk.com/method/users.get'
    params = {
        'user_ids': user_id,
        'access_token': access_token,
        'v': '5.131'
    }
    response = requests.get(url, params=params)
    return response.json()


def connect_to_db():
    try:
        conn = psycopg2.connect(
            dbname="vkdb",
            user="postgres",
            password="user123",
            host="localhost",
            port="5432",
            options="-c client_encoding=UTF8"
        )
        return conn
    except Exception as e:
        print(f"Ошибка подключения к базе данных: {e}")
        return None

def insert_user(conn, user_data):
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Users (user_id, last_name, first_name, city, country, age, friends, grups)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (user_id) DO NOTHING;
            """, (
                user_data['user_id'],
                user_data['surname'],
                user_data['name'],
                user_data['city'],
                user_data['country'],
                user_data['age'],
                user_data['friends'],
                user_data['groups']
            ))
            conn.commit()
    except Exception as e:
        print(f"Ошибка вставки пользователя: {e}")


def insert_group(conn, group_data):
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Grups (group_id, group_name, theme, amount, subscribers)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (group_id) DO NOTHING;
            """, (
                group_data['group_id'],
                group_data['name'],
                group_data['theme'],
                group_data['amount'],
                group_data['subscribers']
            ))
            conn.commit()
    except Exception as e:
        print(f"Ошибка вставки группы: {e}")


def insert_subscription(conn, user_id, group_id):
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Subscriptions (user_id, group_id)
                VALUES (%s, %s)
                ON CONFLICT (user_id, group_id) DO NOTHING;
            """, (user_id, group_id))
            conn.commit()
    except Exception as e:
        print(f"Ошибка вставки подписки: {e}")


def insert_friendship(conn, user1_id, user2_id):
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO Friendships (user1_id, user2_id)
                VALUES (%s, %s)
                ON CONFLICT (user1_id, user2_id) DO NOTHING;
            """, (user1_id, user2_id))
            conn.commit()
    except Exception as e:
        print(f"Ошибка вставки дружбы: {e}")


def fetch_vk_data_and_insert():

    vk_session = vk_api.VkApi(token='vk1.a.3XxH2AaAMKEm_vvs4MMd7obpYM3DkQX0huxXNlBwotVW6-IGfZj226LkquUfBP92GAQuNaFO87DjzWKojaeO1EmeJu6wJLfaMEHx7Y7B6uQCI29DN5vVdR1NLlknct9NAcTYyj9FQ6n1wDm8WoC7g_Z9fSt2JC7eXqbDKdT-7m_IIC1au_SwjoiPPsbSZMhm')
    vk = vk_session.get_api()

    user_id = 'dlmissn'

    user_info = get_vk_user_info(user_id, 'vk1.a.3XxH2AaAMKEm_vvs4MMd7obpYM3DkQX0huxXNlBwotVW6-IGfZj226LkquUfBP92GAQuNaFO87DjzWKojaeO1EmeJu6wJLfaMEHx7Y7B6uQCI29DN5vVdR1NLlknct9NAcTYyj9FQ6n1wDm8WoC7g_Z9fSt2JC7eXqbDKdT-7m_IIC1au_SwjoiPPsbSZMhm')
    id_value = user_info['response'][0]['id']
    user_info = vk.users.get(user_ids=id_value, fields='city,country,bdate')[0]

    friends = vk.friends.get(user_id=id_value)['items']
    groups = vk.groups.get(user_id=id_value)['items']


    user_data = {
        'user_id': user_info['id'],
        'surname': user_info.get('last_name', ''),
        'name': user_info.get('first_name', ''),
        'city': user_info.get('city', {}).get('title', ''),
        'country': user_info.get('country', {}).get('title', ''),
        'age': 2024 - int(user_info['bdate'].split('.')[2]) if 'bdate' in user_info else None,
        'friends': friends,
        'groups': groups
    }


    conn = connect_to_db()
    if conn:
        insert_user(conn, user_data)
        for group_id in groups:
            group_info = vk.groups.getById(group_id=group_id)[0]
            group_data = {
                'group_id': group_info['id'],
                'name': group_info['name'],
                'theme': group_info['description'],
                'amount': group_info['members_count'],
                'subscribers': [user_info['id']]  # Добавляем пользователя как подписчика
            }
            insert_group(conn, group_data)
            insert_subscription(conn, user_info['id'], group_info['id'])
        for friend_id in friends:
            insert_friendship(conn, user_info['id'], friend_id)
        conn.close()

# Вызов функции для заполнения базы
fetch_vk_data_and_insert()
