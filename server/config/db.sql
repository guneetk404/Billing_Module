create table entity(
    id serial primary key,
    name text not null,
    logo_url text,
    email text unique not null,
    contact_details JSON not null,
    country text not null,
    state text,
    city text,
    address text,
    pincode int,
    tax_id text unique not null,
    bank_details JSON,
    status text default 'active',
    currency text not null,
    created_by int,
    created_on timestamp default current_timestamp,
    last_modified_by int,
    last_modified_on timestamp default current_timestamp
);

create table users (
    id serial primary key,
    first_name text not null,
    last_name text,
    email text unique,
    role text default 'admin',
    password text not null,
    status text default 'active',
    created_by int,
    created_on timestamp default current_timestamp,
    last_modified_by int,
    last_modified_on timestamp default current_timestamp,
    entity_id int REFERENCES entity(id)
);

create table audit (
    table_name text not null,
    row_id int not null,
    value JSON,
    operation text not null,
    modified_on timestamp default current_timestamp,
    modified_by int references users(id),
);

create table customer (
    id serial primary key,
    name text not null,
    email text not null,
    contact_details JSON not null,
    status text,
    country text not null,
    state text,
    city text,
    address text,
    pincode int,
    currency text not null,
    website_url text,
    logo_url text,
    created_by int references users(id),
    created_on timestamp default current_timestamp,
    last_modified_by int,
    last_modified_on timestamp default current_timestamp,
);

create table service (
    id serial primary key,
    name text not null,
    created_by int references users(id),
    created_on timestamp default current_timestamp,
    last_modified_by int references users(id),
    last_modified_on timestamp default current_timestamp
);

create table project (
    id serial primary key,
    customer_id int references customer(id),
    name text not null,
    start_date date not null,
    end_date date,
    billing_type text not null,
    billing_period text not null,
    entity_id int references entity(id),
    status text not null,
    created_by int references users(id),
    created_on timestamp default current_timestamp,
    last_modified_by int references users(id),
    last_modified_on timestamp default current_timestamp
);

create table invoice (
    id serial primary key,
    entity_id int references entity(id),
    customer_id int references customer(id),
    project_id int references project(id),
    issue_date date not null,
    due_date date not null,
    duration_start date not null,
    duration_end date not null,
    total_cost float not null,
    status text not null,
    invoice_pdf_path text,
    created_by int references users(id),
    created_on timestamp default current_timestamp,
    last_modified_by int references users(id),
    last_modified_on timestamp default current_timestamp
);

create table entity_customer_relation (
    entity_id int references entity(id),
    customer_id int references customer(id),
    start_date date not null,
    end_date date,
    status text default 'active',
    template_id int
);

create table project_resource (
    id serial primary key,
    resource_id text,
    project_id int references project(id),
    service_id int references service(id),
    daily_hours int,
    hourly_rate decimal not null,
    start_date date not null,
    end_date date,
    created_by int references users(id),
    created_on timestamp default current_timestamp,
    last_modified_by int references users(id),
    last_modified_on timestamp default current_timestamp
);

create table invoice_items(
    id serial primary key,
    invoice_line_item jsonb not null,
    modified_on timestamp default current_timestamp,
    modified_by int
);