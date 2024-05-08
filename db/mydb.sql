PGDMP     +                    |         
   BookReview    9.3.25    9.3.25     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    16640 
   BookReview    DATABASE     �   CREATE DATABASE "BookReview" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Turkish_T�rkiye.1254' LC_CTYPE = 'Turkish_T�rkiye.1254';
    DROP DATABASE "BookReview";
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6            �           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    6                        3079    11750    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1259    16643    book    TABLE     �   CREATE TABLE public.book (
    id integer NOT NULL,
    title character varying(50) NOT NULL,
    key_value character varying(50),
    author character varying(100) NOT NULL
);
    DROP TABLE public.book;
       public         postgres    false    6            �            1259    16641    book_id_seq    SEQUENCE     t   CREATE SEQUENCE public.book_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.book_id_seq;
       public       postgres    false    172    6            �           0    0    book_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.book_id_seq OWNED BY public.book.id;
            public       postgres    false    171            �            1259    16663    review    TABLE       CREATE TABLE public.review (
    id integer NOT NULL,
    book_id integer,
    review text,
    notes text,
    date_read date,
    recommendation_score integer,
    CONSTRAINT review_recommendation_score_check CHECK (((recommendation_score >= 0) AND (recommendation_score <= 10)))
);
    DROP TABLE public.review;
       public         postgres    false    6            �            1259    16661    review_id_seq    SEQUENCE     v   CREATE SEQUENCE public.review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.review_id_seq;
       public       postgres    false    174    6            �           0    0    review_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;
            public       postgres    false    173            &           2604    16646    id    DEFAULT     b   ALTER TABLE ONLY public.book ALTER COLUMN id SET DEFAULT nextval('public.book_id_seq'::regclass);
 6   ALTER TABLE public.book ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    172    171    172            '           2604    16666    id    DEFAULT     f   ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);
 8   ALTER TABLE public.review ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    174    173    174            �          0    16643    book 
   TABLE DATA               <   COPY public.book (id, title, key_value, author) FROM stdin;
    public       postgres    false    172   k       �           0    0    book_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.book_id_seq', 2, true);
            public       postgres    false    171            �          0    16663    review 
   TABLE DATA               ]   COPY public.review (id, book_id, review, notes, date_read, recommendation_score) FROM stdin;
    public       postgres    false    174   �       �           0    0    review_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.review_id_seq', 2, true);
            public       postgres    false    173            *           2606    16648 	   book_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.book DROP CONSTRAINT book_pkey;
       public         postgres    false    172    172            ,           2606    16672    review_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.review DROP CONSTRAINT review_pkey;
       public         postgres    false    174    174            .           2606    16680    unique_book_id 
   CONSTRAINT     S   ALTER TABLE ONLY public.review
    ADD CONSTRAINT unique_book_id UNIQUE (book_id);
 ?   ALTER TABLE ONLY public.review DROP CONSTRAINT unique_book_id;
       public         postgres    false    174    174            /           2606    16673    review_book_id_fkey    FK CONSTRAINT     x   ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id);
 D   ALTER TABLE ONLY public.review DROP CONSTRAINT review_book_id_fkey;
       public       postgres    false    174    1834    172            �   n   x�3��/UpN�S�KM�/�L,IUp̫,���K�4�0035142���H-JRp��H��2��HU��,.I��Rp����4�04�406�06���s�S�M��Z����� o�      �      x��|ˎ$Ǖ��
��̩b��Ң@JT35|��n,�-"���rsϠs���� ��f1�����d�9���GVI#�`EF���>�}������=�q�Nm��T��8Lm�w���)t]쏱
�t�vZ�:��XM�X]�k���B�T���0�C_}w�P��4\�i�����X�l�9��}�Iu��t�_���BJm]��\����~a�Bui���i�/�����㈵������T�~���j�������.V�ax�r-��T�v:Ui��X�9�����o1�_��?��S8_:�1�#8UMX���T���I��eaט�]1Fj�G�e�����X]OQ_�-��;�W>T1]b݂�K�O�K5���~���1��ۄ�E�4`�a\�z�m�����7Cu�����"0�$�P�\�'�,�^��//_T#��o�S�^DK��"�n���W zvC}��p���Ўi��Asйg����oL\���%��
�	���G��1r�XH������ď��3��HD�=��u��6�� ����c_G�{��q�E��-c �����~L���'t��8��'`�%/yX6_�Xǋ��4��OXT2������x��$����]��_�ŧ6^�bȄ���c��
i+�I��r .q� �)gX_���-�x�mn=�o���c����2PLH��pw�;j������Es�~�|L�*�sjg�p�10�يe�;<�0'�ڭY�$,�|��}}/z�5M�jrm����i��t"�w�G鸉홦�:�.e�^Ò��W V��C�5��O��r��4��D�a�2_�j;���(M�7��G������P��~j�m�?A�#溞���A)�8�ٜi�=��Wa�d2pc�#���)��ӄ�/�pc#cN]�y�2���X��4L��{��Q�p8��Lx\�>��SC/l&�\�̖����I{WZ�I�.��tMמ!\O7ߧi錏��_��,�8�l��Z�
��'���t�y��澁ao͎�b��䝰HM %�J��p�����!J���n�ލ��ˣ{���;6r7n�B2]�~�)�J��[ē?���-�_���o��i�>��6����m��=R�2��cs�H[Ը�~\��b�`�I[�>=R�H��^wU�k� l3��֔�z,Z��4t�PN"�1wއn��vNq�B�j�\֛$5�[z�e���蔡��43O�oⶓ���'=��R3��r�@���SkS��5¢�TLӎ�ص�J�����~��������v��W����/?����D���TA�M7_Pqw����k��M��� #��9���J'�p���_�
n��Ͻ��'��>Γ�R�p�Z�\��xD�r�Q�݋h��oM�r@p�`熗��l�J�Gn��/���0��0��G
��yB��(�<���,>�Dl��m8-���Q��#5$���.����CΙ9j�	�R�
�ɒ@2���?I��V����`�>qO�4/�����(��$�h_Ou�\h�����mWr=Ry�t&s��G���&�Mv>Z��.jP#vk�o�9�yF�H��0��� =y7 ��fB�$�@�h;�P6_̙�J��d�Y�U
=��
��"��R��AiEa�����vN�1֛�픓�� ������I��?�w�%�Nu�y%1��rǿ�7���Hv}m�H�\����gV;��y,�F�����B%�NC�H���n�<7�uHؽ�I
o2�}h�(w-�(7&zk O٣`B�Gg<��F憟b��Y���-��hK���^6t*�lN�=�
(�f�[�)��
r����\Aҕc$8Z��)��5` O7C���]���F��(��:Ŏ�`�>� >Ⱥ�P:@��5d�l��Jz�4���b�G�v�#��c����L�c��Y�P�q�b���WA�53$lg: ���Gz��>y�	� K�d���(�>36�ASi|`C\"Rr�#2�0W8��+����I�{\f+�-X��v��g���΀�4�#��U��n�bv�NV����1{N����'��{h<���"�$�8�6�7p\0g���ѦB�B�|r J�	¶`|NQVހ6W���. n��$RJ��Y��i;[�%0s���[{�0�擄���O�*��#��N2K�[��͟���"rI>���T�F[�X�*G�Hc�6Fʜ��"r�'H��Ё}�(�y��A�b�5S�r����������H� �4��v`:s���<�֎lP�
d�ȝ�^�/Y���l��Gu����N�0�&\��#"��6�}r$��m�Q�R m��[
�?����$͎���)JId�>����C����EZ��ID�Y2KB{=H5de�s�v��9BU���;`|�Np��J��Nc�6��=2Ŧ7�n�h8{|�h���2D�O�'�Jܒ�QV0}2s
�=EP�,RJq�|�Ŭ�;��6�D$� �.�l��c���lsT0a���*� {U�L�1G�dĉ�a� �i�M�%Eoɱ�̈́���ɲ���o۟���_���z{�-���O�^�2���� M�{ed��X� ����_� ��� 'C�"}��l��2;�wd�c����1tEU�͑�����55y��ﶩMbm������"�J:��ҙbM)ᮠ�;�E����|�"B��h^�!Ûs�b7�0�ɽ,,~�<��2�4'���	�/a�ΏO@�p)�ɂ?w�W��SE�(b3}O�Ĕ�&j��6�:Z�
><߽h��,���H��H�p^*���G��1^�e�
�� �0���+:m�}zp�Ё]�/�<��OXSc���輙��mQi�C���qlm�]ר�r�"n6��yr�P�!U�{Qx�AB����%���5�K����xs��>�=�Ԉ�vx�چ�r��!(�����@},	�ہ�
��#^4OKN��a)��sr�]��4�ʿ�x.�!�ۜ@��'�U�(/�9c��/h����`���)��̪�[�#Xn��G;�\ �}���Ǹ���R`�]N�O�' X��m9�f�<TPE 1=�V�W�+���Os��<��ѵ��T�����N� �^hV�y��Eh��ގz_��/�E�sܤ>�����S�ﬄb(#�t�+�j��!���������qJ���_JZc�_��Z-�hpL����2d������|$�8������^+��L3 �^ч���86����O��Fʸ=�O���<^T�!��}g�Ϭͤ��s7ZM Og��B檖Mj9��ܓ�V����/fR�Vʻ�/����S�?vTZ�(0؈94�]��D+�9�m�������� `�'&ٖ\
�V����?���^W)��j������
��s)Z|N�5C�T�kΆ.fE���b�]ui�Ga�\e��vB���J4�y�ݴ�g�w��w���W�G�.s:��)[̱��M9 -Zn�Ò�� Z�􊭒��z�T��0�F ��������<���B��'�ꦰlCB#F� G3Lɲsv�D,J��Hm����C�0�ĉf���6rB��˞y2���OJ:2&7����_9�{/�O�=Y�vh�Z���!N�%�c�M���[�("
�3�9��7�8�h |�Ϫ��u����.�B�� �7{��5`O3Գ����9M��~���,��TLAΛ/�T9����LH�[OM�_��pw�y���C�Ѩy�W����&K6�?<Dւ�KJ�J�,J�[_�H��	��C	I���r���������ו~g�g�|�f��6�2o��Ce���[Vo>2�پ&xfN�l �ڬ�;n������#��صJQ��8�������{���Mң����`J��@�e�D�rks�H��+KV﹑�s#��o��^�=��T0��=C�=)	[0װ\2R��:�1��/���K���y�6e'7�����@3����'�ɤ�h����X�Lҕ��dx����2L��":xG��l<ڻ��H^�d��c}��    ۢ8s��W͌`OVd&����o��Aw�Ù�)�yxf��{�gO��u����!�5�q��#l5���b�[f#�e05`�0�Ȫ:BB�7Ѫ��2���"��Z#�G�'��X K���YH3�Vf������Db���r�?�㪉��p���C��ܴE$�Z��U,R��4_�Uf~�=�L��dUO%���֣��#b�9(@�٪�?FH����}*c��,0�� ��bTޡ�㉂�n{�qeI�l����vP�$�ƚ�!�r�cq��H%v[+��;!��OW�������/SD+L��u,`4*#Y�C=J'��S.x�(&!$Sͤkq,��yr�7N����~��#�:B�f�@����,��m�����d�=̵Rvq1����d��Y!A�AX_�T����;x
Á��Vy�p����ϣ����78�m#��t���qe+�M��<�����g�^�g��Ӟ=�c����`Ł�/�Z>-�2K�����������_�B?��}�;�ě3E���^��݋/���3��O/�E��������/Ls�'PsPR��'�3��~\nB ��_�E3�>�Xl:��2���&s�1ʴ�l������5�`��H��E"C�
���<9Z��'{�ԳU��:�[�h;O��s/��q�2�?��D�[;�,m��X)�@M�6c���অճ�N-�K#Ƹ�I!;K�ygo�1�a�.8�e��5���}��W����3 MA�^�v�A1DdH�V�[��V�ӽ0�j�'YI�u�FK^SϹaѐ�*?X�ǁE�b��/H�D� �!� �V�M�y�ԁt��r�2��FHz��4C	�ĩ��V��i�m�: �:��(�X f�_=tO�3{���+�����dK��d.m�Qk������%v���`�HD2xt�z�\o��8�~�lb�=ȋN�$�K''dmŻ�&T�K��JS�~�TA��崤�n�"��#A�R0
��%��xfbo�?Ʒi���#��`	�4l@��f� ! ���K����ޚ'���j��;|U}�X�kS�:<ZMR�l�	�#��9P�p��
㢵s=��`KĊHI�!*���ۆ��{�m
$끯��Gn�xv-I�{��KEȍH��,��Y�;Ԙ��λ�l�ަc�R�i�8H�Z����K&������Xs�����g&@rP��$�@D�lo�Bb=�ٜ�y����jo9C��br�㹯+{������C�56a
���X���>�B������ �ъ�0!�&e}��xj/�r�f��Q��S.K�c�T����O3
ǲH��5���A����ǹiը��eV6��O_�
���T���b����bh�-�$GI]�7�_�׈P�=��>��4��4��p5<V��4k?ǵⰩm�F%��g�(����n�3�YlHL�zp.$����j`�� �uP��{�t�j��.敷�6��4*����!���O��n�\Q�ׯU�ؾ��n��_d�έg�D=�����	�k[H��Þ��m/`o��N�{��*��9�j�pg�<��Ee,����k�9�2�3Ls�!B�Q��r>_X�R�� �M�"��vz��
8;Ռ�D�-.���[�W�:̣��l�A`c{���SmJx��.��|ݶ%��25�0�f���x��$�J���C8LA6�<3�*�!�m���V�L�����O��=c�F	�d	�7��)@�J��j��Ck:���4���Hԓ@�����և�z|R� �'+j��Y�}2�{���>��S��T�er֭w+�Mz�WdR�OxA;�%���ჽE�����G���W
�\����l���]������5%�?oHp��$��R��7�(��b؀��s�;&,s�ܔ������6v����/}�n���S'�gһ�Ɯ�����64m����g��z'�NY����h���#h����H[�9��V�t> �� _Y���}�6[Y��q;�t��f�ν(^��a�.�?��;?���q�B��{8��-��N'����Җh�����9����%������+��e@e�1 ��`�P�$�|��<�<�s*T�}�5Ō��g�Ř�H�� b�\�٫�4�<T�RԎ�c�ZE
Z��~�Wog�t�d	L���`P8.v�/����*��R�pO�4�h�Y�J~�;�О 莻Mh��Sﵠr���y�زЪX2�\ɼ��M���� �5�  t�&I�>�Cڌ���5Q1g����x�n�W��J)K�5�X ZC��à��I0U��,��N��z�4����]+g��	��Þ�;��~-끄��y�սW�`��M�n�Y��R�a��Ϋ/JJHw�P���u�h���N-�b�P��,���uc��OC�S�aLS�z�1Y�����q���z��V��f̆D�u*71�WoO��c*���5۷G/l�%T�$ԫ#�ii��V�ϩ*w�˺Z���M��F�ԅ�1S*E�E�9����bs�F�G��S��n�/M�\~��k��i-雠�lw���1�Kȧ�`�-�Ӊ,���Ȑu{RSuU'm��2��nӋ ���ٮ���E�	DXb����b�?�a�Yd�3f�b	���nD6W����^��2�������������:w�B��p	��W�!��ء�#�𴎤;�����r���\��d�嫉���m�'����m!ʊ�<�0!�5ù��N����jߩ�G�[�����B�g��zoc�3�b�a�J^���L,�f��WD�<��=ϯTǂ��GzBQ硟N�*M�0ѵi�׬Lr1��Ƞ��&��J�=���S��Mӟ��k�|�!��`}f� nͮ~vt�CtQ������s,Σ�c>2E�2M��hlI��c����ܓ�������X���3�"'ò�����4J��C�N�$���]�Z������M���D)��z�2Rf�͒i9N%�r���D6V���s'�q�x�<,]2�R�j�$��#n�3;�lPA�&^�6�V��q1/��b���偵��e��Y|^�[��_�ӋQ|�v���i=C�N�����b_9�Ŝcޢ9�����'��}\F[k��3k�7��Ҡ`��ȁ� �z&�W���Z�N�ܳJ(��d�C2��c�۟sZ"{X_���-<eJ.x�':�P�ĎM*��Ao�(o�gݱ���C����bқ�3e�'r�[���3�+ @8��arŽc_���Aب�ҺJ��~o��r�Y����:��+:�u�m:�zˉo�'��]�&U5J3�c���p<���`���F�g��V�p��g}}o�[�ǋ����=r<;ψaY��ĉ8� �/IX�7/ș09_x����A's��6����Z��z�v`�%s#pv��`уϼ��.�'��k��g�d�w��$ʒ����Z\2����`�R�
�̹��fZ�
��y�zai��Ƣ�m!ς�nN��ya&����E�5Gj�^�SUMg!֌�m�LNh�����~��2����WOm��A-�e�ݙ�~%w�9W^�������£Ϟr|��p�"2�+�tkr�@u��2$��ꪡ����x�oջ�'��\ش�������<����i�v�4��ЃUa���Tr�p��r &\S/���0��3v����5;�jt��1�.:%�uK�:;��co0䞪Q%�S��Z��ڛ����Q������3�`���f�8����������	�xjϥ���_������C��i�xXԵ��	��C�/�.jDa[�)�-a�vV1*�Mb2����X<��
~k ���q;`|n��^���0��F�<m�)�r����g��(g��
Zl���y�$�59�����C�4��&D-��4hss�M�s�QAK[f�C9����4%��)k��&\k���$\s�[{��a5^B_D�:\m]#NSM�B��~�}�lJitl�YC��gUT�����D����a"�o�J+%s-�d�lބ�����5���ub�f�����O�Cio�w�+���ͷ)��Z���
�������0�P%��-�� @  8�?�ѵ��ᇁT�|��9v���e5���������{MfBq������l�j	8���k�v��k6�C�1{?U�����_|����r��_?x���]���fK�%a������F),X�rJ����=0��3�4�T��7g��9�Y^ǒJ࿞�sb�B�$���5%x�G�Tk���Q)�]�:iM8���vXe��R��Z��@��/E��Q$lw��Q�m��x޳����r�8��Tu,�E��j%4f��"]�vI�Z���e�A*J��n���k�*'������+�����Υ2��}ݭ�����֞`]�:@��BҦ�� Q�'��.ȇ\u P�D�|v����۩Ɩ� ��L[��Ԧ\���rr�%è�d�3Hˁ����,��;�č<0�X-AE�æ�s�~ۅ1P[<��������`GA&l�y9f� ��.v��q�j��ZY�f�b��w!u<\f�#��I����UA��̔��6G�����r�c0� s���몁�`M�":��w�7\�v��1���+%"D+�lt��r?O꬝����ȷ���ؼq�y=(-�w<�њXT���*���+��3"��*{�3uvG�E=�]<�|���I�rT�+�; �K��5�te3�9�����.�۬������
�-|�Q-�P�h���;pQ�hu[������?��$�$6��Y{������=-~m�.0�͸��� �f�C�IA"cw<�l��x�}ޑDa�#��}*�vs���c��SF�ox���v���vI�k�ͷ�x��ƶ^�Y. 7���{&d�-��y�g��:�{��7%��BTW�(7�ֿ�%ev2os+��h3�U[icw�v��������(�C_ Y~yGqP�U\�k�R�~��`�D7&x�9���k��T=��N�b�-	,$��0��d�\¢VY5")�Ew>��j�u���,��̉a �I�-n�A�h�R�Qm^͎R��"�@fw��m�/���n�q�o�ft�xxvV��4�&�'^��}8����l��@O�rPcZ�	��a�� tU��>]��+���&+e`J�������?�>R��L��7v`��S�M���Ȭ�r?�|ዹ^���.�.��z�S�go�w
��eUS7%��XMg��N��vsk�W`�x�9�ꋙgtXʨ�%��ކ'+���I�w쀔 ��W[� ��x3~Ӫ�("ݣ��^�Q��0{�2��Ad����fʕ�~ѕ�Ky��s�FC�,�� [lY�<����v�l�HiB�R]�|yvp�Y��2� 0j��;���2��!�Uug6'#�KZ���Kx������٧�/����ҮZ�Ү_Ro��"��4ܒ�,fV^�������@��ۆ0��M� Vw��t�\�F��}�动�A��L�ڔ>3��0�j�3�9�x��w��ZMaO��<٦��r~��Z۽�Ȅ���_����Tt�u��b�������uR���~��$:�2��~��򫑷��e�wϪ��He2��-%o:�ˍ&)G
�ʏ־i���63�,�t=���~����_���>H     