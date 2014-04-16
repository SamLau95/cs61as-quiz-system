--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE options (
    id integer NOT NULL,
    content text,
    question_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE options_id_seq OWNED BY options.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    content text,
    number integer,
    quiz_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    points integer DEFAULT 0 NOT NULL,
    type character varying(255),
    lesson integer,
    difficulty character varying(255)
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: quiz_locks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quiz_locks (
    id integer NOT NULL,
    student_id integer,
    quiz_id integer,
    locked boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: quiz_locks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quiz_locks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quiz_locks_id_seq OWNED BY quiz_locks.id;


--
-- Name: quiz_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quiz_requests (
    id integer NOT NULL,
    student_id integer,
    lesson integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    approved boolean DEFAULT false,
    retake boolean DEFAULT false
);


--
-- Name: quiz_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quiz_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quiz_requests_id_seq OWNED BY quiz_requests.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quizzes (
    id integer NOT NULL,
    lesson integer,
    version integer,
    retake boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_draft boolean DEFAULT true
);


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quizzes_id_seq OWNED BY quizzes.id;


--
-- Name: relationships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE relationships (
    id integer NOT NULL,
    quiz_id integer,
    question_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE relationships_id_seq OWNED BY relationships.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: solutions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE solutions (
    id integer NOT NULL,
    content text,
    question_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE solutions_id_seq OWNED BY solutions.id;


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE submissions (
    id integer NOT NULL,
    content text,
    question_id integer,
    student_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    quiz_id integer
);


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submissions_id_seq OWNED BY submissions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying(255),
    first_name text,
    last_name text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY options ALTER COLUMN id SET DEFAULT nextval('options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quiz_locks ALTER COLUMN id SET DEFAULT nextval('quiz_locks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quiz_requests ALTER COLUMN id SET DEFAULT nextval('quiz_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quizzes ALTER COLUMN id SET DEFAULT nextval('quizzes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY relationships ALTER COLUMN id SET DEFAULT nextval('relationships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY solutions ALTER COLUMN id SET DEFAULT nextval('solutions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY submissions ALTER COLUMN id SET DEFAULT nextval('submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quiz_locks
    ADD CONSTRAINT quiz_locks_pkey PRIMARY KEY (id);


--
-- Name: quiz_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quiz_requests
    ADD CONSTRAINT quiz_requests_pkey PRIMARY KEY (id);


--
-- Name: quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_pkey PRIMARY KEY (id);


--
-- Name: solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_pkey PRIMARY KEY (id);


--
-- Name: submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_questions_on_number_and_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_questions_on_number_and_quiz_id ON questions USING btree (number, quiz_id);


--
-- Name: index_quiz_requests_on_student_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quiz_requests_on_student_id ON quiz_requests USING btree (student_id);


--
-- Name: index_quizzes_on_lesson_and_version_and_retake; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_quizzes_on_lesson_and_version_and_retake ON quizzes USING btree (lesson, version, retake);


--
-- Name: index_relationships_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_relationships_on_question_id ON relationships USING btree (question_id);


--
-- Name: index_relationships_on_question_id_and_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_relationships_on_question_id_and_quiz_id ON relationships USING btree (question_id, quiz_id);


--
-- Name: index_relationships_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_relationships_on_quiz_id ON relationships USING btree (quiz_id);


--
-- Name: index_solutions_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_solutions_on_question_id ON solutions USING btree (question_id);


--
-- Name: index_submissions_on_question_id_and_student_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_submissions_on_question_id_and_student_id ON submissions USING btree (question_id, student_id);


--
-- Name: index_submissions_on_quiz_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_quiz_id ON submissions USING btree (quiz_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140303043042');

INSERT INTO schema_migrations (version) VALUES ('20140303060628');

INSERT INTO schema_migrations (version) VALUES ('20140303060635');

INSERT INTO schema_migrations (version) VALUES ('20140303061336');

INSERT INTO schema_migrations (version) VALUES ('20140303061339');

INSERT INTO schema_migrations (version) VALUES ('20140303074133');

INSERT INTO schema_migrations (version) VALUES ('20140303074434');

INSERT INTO schema_migrations (version) VALUES ('20140303075525');

INSERT INTO schema_migrations (version) VALUES ('20140303092825');

INSERT INTO schema_migrations (version) VALUES ('20140303095923');

INSERT INTO schema_migrations (version) VALUES ('20140305082414');

INSERT INTO schema_migrations (version) VALUES ('20140305083132');

INSERT INTO schema_migrations (version) VALUES ('20140306075216');

INSERT INTO schema_migrations (version) VALUES ('20140320085809');

INSERT INTO schema_migrations (version) VALUES ('20140320102936');

INSERT INTO schema_migrations (version) VALUES ('20140320104015');

INSERT INTO schema_migrations (version) VALUES ('20140320230116');

INSERT INTO schema_migrations (version) VALUES ('20140320235415');

INSERT INTO schema_migrations (version) VALUES ('20140321205957');

INSERT INTO schema_migrations (version) VALUES ('20140321214945');

INSERT INTO schema_migrations (version) VALUES ('20140321231658');

INSERT INTO schema_migrations (version) VALUES ('20140322074211');

INSERT INTO schema_migrations (version) VALUES ('20140322092443');

INSERT INTO schema_migrations (version) VALUES ('20140322104003');

INSERT INTO schema_migrations (version) VALUES ('20140322104116');

INSERT INTO schema_migrations (version) VALUES ('20140323013146');

INSERT INTO schema_migrations (version) VALUES ('20140323013426');

INSERT INTO schema_migrations (version) VALUES ('20140323024707');

INSERT INTO schema_migrations (version) VALUES ('20140323025054');

INSERT INTO schema_migrations (version) VALUES ('20140328213513');

INSERT INTO schema_migrations (version) VALUES ('20140329033921');

INSERT INTO schema_migrations (version) VALUES ('20140408035759');

INSERT INTO schema_migrations (version) VALUES ('20140410015709');

INSERT INTO schema_migrations (version) VALUES ('20140410035117');

INSERT INTO schema_migrations (version) VALUES ('20140416081729');
