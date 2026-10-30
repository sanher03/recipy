--
-- PostgreSQL database dump
--

\restrict tVIUO6GICuf7dmdhMFy4Eqxc5IvTym0TvmWjVz211RP4IOIKr4NmnoCRUFfNCy5

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    recipe_id integer,
    author text,
    content text NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recipes (
    id integer NOT NULL,
    title text NOT NULL,
    diners integer NOT NULL,
    ingredients text[] NOT NULL,
    author character varying(30) NOT NULL,
    image text DEFAULT 'img/recipe.png'::text,
    descr text,
    instructions text[]
);


--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: saved_recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saved_recipes (
    username character varying(30) NOT NULL,
    recipe_id integer NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    username character varying(30) NOT NULL,
    email character varying(320) NOT NULL,
    name character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    profile_pic text DEFAULT '../img/user.png'::text
);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, recipe_id, author, content) FROM stdin;
34	26	sanher03	Just as my grandma's old rice!
35	10	sanher03	me dio asco
36	25	sanher03	muy ricas alitas!
9	6	vsdv	Perfectly cooked salmon in 15 minutes!
12	8	vsdv	A bit of a stir but totally worth it. Rich and creamy.
15	11	vsdv	Comforting and budget-friendly. Perfect for fall.
2	1	f23ds	Really healthy and easy to make.
5	3	f23ds	Quick and fresh, great as a side dish.
8	5	f23ds	Great one-pot meal. Very filling.
11	7	f23ds	My go-to breakfast.
13	9	f23ds	Tastes like summer on a plate.
16	12	f23ds	My kids loved them! Fluffy and golden.
28	14	f23ds	Perfect spanish paella!
29	11	f23ds	Perfect for a cold day.
30	17	sanher03	Perfectly cooked chicken! Really enjoyed how it goes with the lemon.
1	1	sanher03	This soup reminds me of my grandmother. Comfort food!
10	7	sanher03	Simple, quick, and delicious.
14	10	sanher03	Great flavor. I added some guacamole too.
17	5	sanher03	Amazing recipe!
18	1	sanher03	Very practical recipe!
24	1	sanher03	Amazing taste!
26	10	sanher03	Amazing. Some lemon goes perfectly with them!
27	9	sanher03	It lacks a bit of protein.
31	9	juanito23	Amazing and refreshing salad!
32	6	juanito25	best meal ever
33	11	pedrito12	amazing soup!
\.


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recipes (id, title, diners, ingredients, author, image, descr, instructions) FROM stdin;
10	Beef Tacos	4	{"Taco shells","Ground beef",Onion,"Cheddar cheese",Lettuce}	vsdv	../img/recipe.png	Delicious beef tacos with seasoned ground beef, cheese, and fresh lettuce.	{"Cook beef with onions, assemble tacos with toppings."}
11	Lentil Soup	3	{Lentils,Carrot,Celery,Onion,Garlic,Salt}	vsdv	../img/recipe.png	Hearty lentil soup perfect for cold days, rich in vegetables.	{"Boil everything until soft. Blend if desired."}
12	Pancakes	2	{Flour,Eggs,Milk,Sugar,Butter}	vsdv	../img/recipe.png	Fluffy pancakes ideal for breakfast, made with milk, eggs and sugar.	{"Mix all ingredients, cook in pan on both sides."}
3	Mixed Salad	3	{Lettuce,Tomato,Cucumber,Onion,Vinegar,"Olive oil"}	sanher03	../img/recipe.png	Fresh mixed salad with tomato, cucumber and vinaigrette.	{"Slice all ingredients and mix in a bowl. Dress with vinegar and olive oil."}
5	Chicken Rice	5	{Rice,Chicken,"Bell pepper",Onion,Garlic,Tomato,"Chicken broth"}	f23ds	../img/recipe.png	Savory chicken rice with vegetables and broth, perfect as a meal.	{"Sauté ingredients, add broth and rice, and cook until tender."}
6	Grilled Salmon	2	{"Salmon fillet",Lemon,Garlic,"Olive oil",Salt}	f23ds	../img/recipe.png	Grilled salmon with lemon and garlic, light and healthy option.	{"Marinate the salmon and grill for 10 minutes."}
7	Avocado Toast	1	{Bread,Avocado,Lime,Salt,"Chili flakes"}	f23ds	../img/recipe.png	Simple avocado toast on crispy bread with chili flakes.	{"Toast the bread, mash the avocado with lime and salt, and top with chili flakes."}
8	Mushroom Risotto	3	{"Arborio rice",Mushrooms,Onion,Parmesan,"Vegetable broth"}	f23ds	../img/recipe.png	Creamy mushroom risotto with Parmesan and rich broth.	{"Cook onions and mushrooms, add rice and broth gradually, then stir in parmesan."}
9	Caprese Salad	2	{Tomato,Mozzarella,Basil,"Olive oil",Salt}	f23ds	../img/recipe.png	Refreshing caprese salad with mozzarella, tomato and basil.	{"Slice ingredients and arrange on plate. Drizzle with oil and season."}
15	Chickpea Curry with Coconut Milk	3	{chickpeas,curry,"2 tablespoons of coconut milk"}	albs	../img/recipes/recipe_682c771d85298.jpg	\N	{"Sauté the chickpeas with the curry, and add the coconut milk"}
16	Creamy Tomato Basil Soup	2	{"olive oil",onion,garlic,"canned tomatoes","vegetable broth","fresh basil","heavy cream",salt,pepper}	albs	../img/recipes/recipe_682c8c5e06044.jpeg	A smooth and comforting soup made with ripe tomatoes, fresh basil, and a touch of cream.	{"Heat olive oil in a pot and sauté onion and garlic until soft.\r","\r","Add canned tomatoes and vegetable broth. Simmer for 15 minutes.\r","\r","Add fresh basil and blend the soup until smooth.\r","\r","Stir in heavy cream, season with salt and pepper, and heat gently before serving."}
17	Lemon Garlic Roasted Chicken	2	{"1 whole chicken (about 1.5 kg)","2 lemons","1 head of garlic","3 tbsp olive oil","2 tsp dried oregano","1 tsp salt","½ tsp black pepper","Fresh parsley for garnish"}	albs	../img/recipes/recipe_682ca451bb09b.jpeg	Perfectly roasted chicken with lemon flavor.	{"Preheat the oven to 200°C (400°F).","Clean the chicken and pat it dry with paper towels.","Cut one lemon into quarters and place it inside the chicken cavity along with half of the garlic head."}
13	Creamy Mushroom Risotto	2	{"200g arborio rice","500ml vegetable broth","100g mushrooms","1 onion","1 garlic clove","50g parmesan","1 tbsp olive oil",salt,pepper}	sanher03	../img/recipe.png	Deluxe mushroom risotto with extra creamy finish.	{"1. Heat olive oil in a pan and sauté chopped onion and garlic.\r","2. Add sliced mushrooms and cook until soft.\r","3. Stir in the rice and toast for 1-2 minutes.\r","4. Gradually add broth, stirring constantly until absorbed.\r","5. When rice is al dente, stir in parmesan and season to taste.\r","6. Serve warm with extra cheese on top.\r",""}
1	Vegetable Soup	4	{Carrot,Celery,Onion,Leek,Salt}	sanher03	../img/recipe.png	Vegetable soup loaded with healthy ingredients and flavor.	{"Chop all vegetables, simmer in water for 30 minutes, and season with salt."}
20	Gazpacho	3	{"3 tomatoes","olive oil",inion,garlic}	sanher03	../img/recipes/recipe_682cbb8a9a2c7.jpg	Refreshing tomato juice	{"Boil everything together","Beat until you achieve your preferred consistency"}
14	Seafood Paella	4	{"2 cups rice","1 liter fish broth","200g shrimp","200g mussels","200g squid rings","1 onion","1 garlic clove","1 tomato","1 tsp paprika","1 pinch saffron","olive oil",salt}	sanher03	../img/recipes/recipe_682b119b6a2b6.jpg	Seafood paella with shrimp, mussels and saffron.	{"1. Heat olive oil in a large paella pan and sauté chopped onion and garlic.\r","2. Add diced tomato and cook until soft.\r","3. Stir in rice and paprika, and toast lightly.\r","4. Add fish broth and saffron. Bring to a boil.\r","5. Add shrimp, mussels, and squid. Reduce heat and simmer without stirring.\r","6. Cook for 15–20 minutes until rice is tender and broth is absorbed.\r","7. Let rest 5 minutes and serve warm with lemon wedges.\r",""}
25	BBQ Chicken Wings	3	{"1 chicken","olive oil",garlic,onion}	juanito23	../img/recipes/recipe_682d1818103b1.jpeg	Perfectly cooked chicken wings.	{"Cut the chicken's wings","Fry the wings","Add the garlic and onion"}
26	Cuban Rice	3	{Rice,sausage,eggs,bananas,tomato}	juanito25	../img/recipes/recipe_682d778916953.jpg	Perfect meal for a hot summer	{"Boil the rice","Fry the eggs","Add the banana and the tomato"}
27	Pizza	2	{Flour,tomato,mozarella,"olive oil"}	pedrito12	../img/recipes/recipe_682e1ea59a996.jpg	Perfect pizza for 2 people	{"Make the dough","Add the tomato and the mozarella","Put it in the oven"}
30	burrata con tomate	5	{"1 burrata","1 tomate",pesto,"1 cucharada de aceite",piñones}	sanher03	../img/recipes/recipe_689607f76d6de.jpg	Rica ensalada de queso y tomate	{"cortar la burrata","cortar el tomate",emplatar,"añadir el aceite y los piñones"}
\.


--
-- Data for Name: saved_recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.saved_recipes (username, recipe_id) FROM stdin;
juanito25	6
juanito25	5
juanito25	7
juanito25	12
juanito25	11
juanito25	3
juanito25	1
f23ds	11
f23ds	12
f23ds	3
albs	1
albs	5
albs	11
albs	15
pedrito12	11
albs	3
albs	20
sanher03	1
albs	14
sanher03	6
sanher03	8
sanher03	25
sanher03	5
sanher03	26
sanher03	15
huguito	25
huguito	30
sanher03	17
juanito23	9
juanito23	20
sanher03	11
sanher03	12
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (username, email, name, password, profile_pic) FROM stdin;
albs	albs123@gmail.com	Alba	$2y$10$qt.pn6XwXU.VWOvnwbRlteaTpaVLazxIOsr0VCDKf1pi.K7VhEWSO	../img/profiles/alb.jpg
sanher03	hola123@gmail.com	Ignacio	$2y$10$bFj0dfHpCPInCxRF/J0iSOlOEHrxw.zCgGRYpRzzee2NgOAZ7hk4e	../img/profiles/sanher03.jpg
huguito	hugo@gmail.com	hugo	$2y$10$vquaABV7ceD.z2iFYZAF7ecWAIUD0wnI6NcP6cNWJs9nfcScKwdMi	../img/user.png
vsdv	pis123@gmail.com	Victor	$2y$10$U1/C36sglVal.FRS69uAoeO9diDVuKyO1erJVRUjAzuW0HG/sTnCm	../img/user.png
f23ds	caca123@gmail.com	Fabio	$2y$10$u74mJCQoF4xcfhWRL0jMv.Wk16G3HWcoqttzmf.hgT9xklFqTgfda	../img/profiles/f23ds.png
juanito23	juan@gmail.com	Juan	$2y$10$SN6PfXQPD.G7a3BwQtoKQ.4Lwrzmaf7w5eo5N8QOvuzkpiiny4jbu	../img/profiles/juanito23.jpeg
juanito25	juan123@gmail.com	Juan	$2y$10$Ufje4KfkX8.lHp442TGxeO48h6GLOz7DyMt5OpOnL85zD/i94gvXK	../img/profiles/juanito25.jpg
pedrito12	pedro@gmail.com	Pedro	$2y$10$vkwUo18S74kjGiM/NKOd/.4SXX3un/g6Qx.PezMDF79Glr2rlbkgm	../img/profiles/pedrito12.jpg
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 36, true);


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recipes_id_seq', 30, true);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: saved_recipes saved_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_recipes
    ADD CONSTRAINT saved_recipes_pkey PRIMARY KEY (username, recipe_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (username);


--
-- Name: comments comments_author_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_author_fkey FOREIGN KEY (author) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: comments comments_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: recipes recipes_author_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_author_fkey FOREIGN KEY (author) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: saved_recipes saved_recipes_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_recipes
    ADD CONSTRAINT saved_recipes_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: saved_recipes saved_recipes_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_recipes
    ADD CONSTRAINT saved_recipes_username_fkey FOREIGN KEY (username) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict tVIUO6GICuf7dmdhMFy4Eqxc5IvTym0TvmWjVz211RP4IOIKr4NmnoCRUFfNCy5
