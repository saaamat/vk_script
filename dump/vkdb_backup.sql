PGDMP                     
    |            vkdb    15.8    15.8     
           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            
           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            
           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            
           1262    115225    vkdb    DATABASE     x   CREATE DATABASE vkdb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE vkdb;
                postgres    false            �            1259    115259    friendships    TABLE     b   CREATE TABLE public.friendships (
    user1_id integer NOT NULL,
    user2_id integer NOT NULL
);
    DROP TABLE public.friendships;
       public         heap    postgres    false            �            1259    115236    grups    TABLE     �   CREATE TABLE public.grups (
    group_id integer NOT NULL,
    group_name character varying(255),
    theme character varying(255),
    amount integer,
    subscribers integer[]
);
    DROP TABLE public.grups;
       public         heap    postgres    false            �            1259    115235    grups_group_id_seq    SEQUENCE     �   CREATE SEQUENCE public.grups_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.grups_group_id_seq;
       public          postgres    false    217            
           0    0    grups_group_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.grups_group_id_seq OWNED BY public.grups.group_id;
          public          postgres    false    216            �            1259    115244 
   subscriptions    TABLE     c   CREATE TABLE public.subscriptions (
    user_id integer NOT NULL,
    group_id integer NOT NULL
);
 !   DROP TABLE public.subscriptions;
       public         heap    postgres    false            �            1259    115227    users    TABLE       CREATE TABLE public.users (
    user_id integer NOT NULL,
    last_name character varying(255),
    first_name character varying(255),
    city character varying(255),
    country character varying(255),
    age integer,
    friends integer[],
    grups integer[]
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    115226    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    215            
           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    214            s           2604    115239    grups group_id    DEFAULT     p   ALTER TABLE ONLY public.grups ALTER COLUMN group_id SET DEFAULT nextval('public.grups_group_id_seq'::regclass);
 =   ALTER TABLE public.grups ALTER COLUMN group_id DROP DEFAULT;
       public          postgres    false    216    217    217            r           2604    115230 
   users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214    215            
          0    115259    friendships 
   TABLE DATA           9   COPY public.friendships (user1_id, user2_id) FROM stdin;
    public          postgres    false    219   �       
          0    115236    grups 
   TABLE DATA           Q   COPY public.grups (group_id, group_name, theme, amount, subscribers) FROM stdin;
    public          postgres    false    217   �       
          0    115244 
   subscriptions 
   TABLE DATA           :   COPY public.subscriptions (user_id, group_id) FROM stdin;
    public          postgres    false    218            
          0    115227    users 
   TABLE DATA           c   COPY public.users (user_id, last_name, first_name, city, country, age, friends, grups) FROM stdin;
    public          postgres    false    215           
           0    0    grups_group_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.grups_group_id_seq', 1, false);
          public          postgres    false    216            
           0    0    users_user_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);
          public          postgres    false    214            {           2606    115263    friendships friendships_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (user1_id, user2_id);
 F   ALTER TABLE ONLY public.friendships DROP CONSTRAINT friendships_pkey;
       public            postgres    false    219    219            w           2606    115243    grups grups_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.grups
    ADD CONSTRAINT grups_pkey PRIMARY KEY (group_id);
 :   ALTER TABLE ONLY public.grups DROP CONSTRAINT grups_pkey;
       public            postgres    false    217            y           2606    115248     subscriptions subscriptions_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (user_id, group_id);
 J   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_pkey;
       public            postgres    false    218    218            u           2606    115234    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    215            ~           2606    115264 %   friendships friendships_user1_id_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_user1_id_fkey FOREIGN KEY (user1_id) REFERENCES public.users(user_id);
 O   ALTER TABLE ONLY public.friendships DROP CONSTRAINT friendships_user1_id_fkey;
       public          postgres    false    219    215    3189                       2606    115269 %   friendships friendships_user2_id_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_user2_id_fkey FOREIGN KEY (user2_id) REFERENCES public.users(user_id);
 O   ALTER TABLE ONLY public.friendships DROP CONSTRAINT friendships_user2_id_fkey;
       public          postgres    false    215    219    3189            |           2606    115254 )   subscriptions subscriptions_group_id_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.grups(group_id);
 S   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_group_id_fkey;
       public          postgres    false    3191    217    218            }           2606    115249 (   subscriptions subscriptions_user_id_fkey 
   FK CONSTRAINT     �   ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);
 R   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_user_id_fkey;
       public          postgres    false    3189    218    215            
   
   x������ � �      
   
   x������ � �      
   
   x������ � �      
   �  x��͍dE��=��PV����9����h=@�{f=��7���z��'22ګE,�>����߾��>�����/?���������~|����_���ןj��bG�ˣ�TONV����sE�ťϽ9�bz����>�
��qn\�f�E��(�9׭�T�,j��yI��w�P�%9b�Z���2׵Ȗv3ʉ��f�����J\d��I�
��!o���"�X�{5Q�d�CE�l52Ńs[m(!yD�S̍&r�S���z��ۀ��Xt�S7��=�[�@���E�>oҘŕ�=HE��e@�N~�����:zɻ�H�i{咠Ϻq�'J)�#�׏Rޕ',3��E�@�l�l)�ApU�O[�����w���-�k��?ds�5������)0�	]���F���j��:|ϲ�N)���s(T�v(����z�M��;�:T<��\�&�6l3�����c�'_�6y
����oh��ԩ+܈��Ɂ2�=�R�۞���Y��c���\&�s9CM����Ŵ ������3�54�*Tb��I�O��(�8�\����-p��1?���ƃ T�D16��ah�s�S�)٨��,Br[�W^5�8�g�`��C[,��/�U~�@M�?q��0&P;�UΔ�G���S�
�t�_
j(�����t��H�=v]�:�-L¾�j	�v ���*kK:n$���Qӊ�e�DT�`��\d�X��g�tՑ��;	�k��x$jc�@�|�X���jM�?������U5�a��ܤVc� ��k!�~�&�8C1BP�&����Ӱs低G���$ֻ�@��5Q6e�屄�ݗ&YT\MCV��δ���ׇ�13W�&Ţ<�	�C��Cc�X�bwh@�h]��~�a�<��w��D�Cq���2Y$���%�E�]�@a,T���3��|�_czҳ�c�7�R ��%f��E��w�<���o?�����?��{�     