CREATE TABLE IF NOT EXISTS users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(32)  NOT NULL,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role          VARCHAR(20)  NOT NULL DEFAULT 'user',
    display_name  VARCHAR(64)  NULL,
    bio           TEXT         NULL,
    avatar_url    VARCHAR(512) NULL,
    registered_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS collection (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT          NOT NULL,
    name        VARCHAR(255) NOT NULL,
    description TEXT         NULL,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS snippet (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT          NOT NULL,
    collection_id INT          NULL,
    title         VARCHAR(255) NOT NULL,
    description   TEXT         NULL,
    code          TEXT         NOT NULL,
    language      VARCHAR(50)  NOT NULL,
    visibility    VARCHAR(20)  NOT NULL DEFAULT 'private',
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)       REFERENCES users(id)      ON DELETE CASCADE,
    FOREIGN KEY (collection_id) REFERENCES collection(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS tag (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS snippet_tag (
    snippet_id INT NOT NULL,
    tag_id     INT NOT NULL,
    PRIMARY KEY (snippet_id, tag_id),
    FOREIGN KEY (snippet_id) REFERENCES snippet(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id)     REFERENCES tag(id)     ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS snippet_shares (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    snippet_id        INT       NOT NULL,
    shared_with_user_id INT     NOT NULL,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (snippet_id)          REFERENCES snippet(id) ON DELETE CASCADE,
    FOREIGN KEY (shared_with_user_id) REFERENCES users(id)   ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS snippet_version (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    snippet_id     INT     NOT NULL,
    code           TEXT    NOT NULL,
    version_number INT     NOT NULL,
    change_note    TEXT    NULL,
    created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (snippet_id) REFERENCES snippet(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS comment (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT       NOT NULL,
    snippet_id INT       NOT NULL,
    content    TEXT      NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
    FOREIGN KEY (snippet_id) REFERENCES snippet(id) ON DELETE CASCADE
);
