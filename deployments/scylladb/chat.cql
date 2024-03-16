CREATE KEYSPACE chatbackend
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

USE chatbackend;

CREATE TABLE users (
    user_id uuid PRIMARY KEY,
    name text,
    phone_number text,
    profile_pic_url text,
    bio text,
    email text,
    password text,
    last_seen timestamp,
    status text,
    about text,
    created_at timestamp,
    updated_at timestamp,
    is_online boolean,
    is_verified boolean,
    is_blocked boolean,
    blocked_by set<uuid>,
    blocked_users set<uuid>,
    privacy_settings map<text, text>,
    notification_settings map<text, text>,
    language text,
    country text,
    timezone text
);

CREATE TABLE conversations (
    conversation_id uuid,
    participant1 uuid,
    participant2 uuid,
    created_at timestamp,
    last_message_at timestamp,
    PRIMARY KEY (participant1, participant2)
);

CREATE TABLE conversation_message_counters (
    msgnum counter,
    conversation_id uuid,
    PRIMARY KEY(conversation_id)
);

CREATE TABLE conversation_messages (
    conversation_id uuid,
    message_id timeuuid,
    sender uuid,
    recipient uuid,
    content text,
    sent_at timestamp,
    PRIMARY KEY ((conversation_id), message_id)
) WITH CLUSTERING ORDER BY (message_id DESC);

CREATE TABLE status_updates (
    user_id uuid,
    status_id timeuuid,
    content text,
    media_url text,
    posted_at timestamp,
    PRIMARY KEY ((user_id), status_id)
) WITH CLUSTERING ORDER BY (status_id DESC);

CREATE TABLE user_contacts (
    user_id uuid,
    contact_id uuid,
    contact_name text,
    PRIMARY KEY (user_id, contact_id)
);

CREATE TABLE unread_conversation_messages (
    user_id uuid,
    conversation_id uuid,
    last_read_message_id timeuuid,
    PRIMARY KEY (user_id, conversation_id)
);

CREATE TABLE groups (
    group_id uuid PRIMARY KEY,
    name text,
    description text,
    avatar_url text,
    created_at timestamp,
    created_by uuid,
    group_type text,
    is_private boolean,
    join_mode text,
    group_link text,
    members_count counter,
    last_message_at timestamp,
    muted_by set<uuid>,
    pinned_messages set<timeuuid>,
    group_settings map<text, text>
);

CREATE TABLE group_message_counters (
    msgnum counter,
    group_id uuid,
    PRIMARY KEY(group_id)
);

CREATE TABLE group_members (
    group_id uuid,
    user_id uuid,
    role text,
    joined_at timestamp,
    PRIMARY KEY (group_id, user_id)
);

CREATE TABLE group_messages (
    group_id uuid,
    message_id timeuuid,
    sender uuid,
    content text,
    sent_at timestamp,
    PRIMARY KEY ((group_id), message_id)
) WITH CLUSTERING ORDER BY (message_id DESC);

CREATE TABLE channels (
    channel_id uuid PRIMARY KEY,
    name text,
    description text,
    avatar_url text,
    created_at timestamp,
    created_by uuid,
    channel_type text,
    category text,
    is_public boolean,
    join_mode text,
    channel_link text,
    subscribers_count counter,
    last_message_at timestamp,
    muted_by set<uuid>,
    pinned_messages set<timeuuid>,
    channel_settings map<text, text>,
    tags set<text>,
    language text,
    rules text,
    announcement_channel uuid
);

CREATE TABLE channel_message_counters (
    msgnum counter,
    channel_id uuid,
    PRIMARY KEY(channel_id)
);

CREATE TABLE channel_subscribers (
    channel_id uuid,
    user_id uuid,
    subscribed_at timestamp,
    PRIMARY KEY (channel_id, user_id)
);

CREATE TABLE channel_messages (
    channel_id uuid,
    message_id timeuuid,
    content text,
    sent_at timestamp,
    PRIMARY KEY ((channel_id), message_id)
) WITH CLUSTERING ORDER BY (message_id DESC);
