#language:ru
@Test_photo

Функционал: Работа с фотографиями
  - Создать приватный альбом
  - Добавить фотографию в альбом
  - Сделать фотографию обложкой альбома
  - Прокомментировать фотографию
  - Добавить отметку на фотографию
  - Создать публичный альбом
  - Перенести туда фотографию
  - Удалить первый альбом

  Сценарий: Работа с фотографиями

    # Создать приватный альбом
    # вместо токен указать токен Standalone приложения
    * создать контекстные переменные
      | token               | токен Standalone            |
      | v                   | 5.131                       |
      | title_private       | Приватный альбом            |
      | description_private | Описание приватного альбома |
      | title_public        | Публичный альбом            |
      | description_public  | Описание публичного альбома |
      | file_photo_path     | .\src\test\resources        |
      | file_photo_name     | photo.jpg                   |
      | message_photo       | Прикольная фотка            |
      | user_id             | 690043267                   |
      | x                   | 10                          |
      | y                   | 10                          |
      | x2                  | 80                          |
      | y2                  | 80                          |

    Пусть создать запрос
      | method | path                       |
      | GET    | /method/photos.createAlbum |
    И добавить query параметры
      | access_token    | ${token}               |
      | title           | ${title_private}       |
      | description     | ${description_private} |
      | privacy_view    | only_me                |
      | privacy_comment | only_me                |
      | v               | ${v}                   |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | album_private_id | $.response.id |

    #Добавить фотографию в альбом
    # получить адрес
    Пусть создать запрос
      | method | path                           |
      | GET    | /method/photos.getUploadServer |
    И добавить query параметры
      | access_token | ${token}            |
      | album_id     | ${album_private_id} |
      | v            | ${v}                |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | upload_url | $.response.upload_url |

    # загруpить фото
    Пусть создать запрос
      | method | url           |
      | POST   | ${upload_url} |
    И добавить multipart-form-data query параметры для загрузки файла
      | file1 | ${file_photo_path} | ${file_photo_name} |
    Когда отправить multipart-form-data запрос
    Тогда статус код 200
    И извлечь данные
      | server      | $.server      |
      | photos_list | $.photos_list |
      | hash        | $.hash        |
      | aid         | $.aid         |

    # сохранить фото
    Пусть создать запрос
      | method | path                |
      | POST   | /method/photos.save |
    И добавить header
      | Connection | keep-alive |
    И добавить query параметры
      | access_token | ${token}            |
      | album_id     | ${album_private_id} |
      | aid          | ${aid}              |
      | server       | ${server}           |
      | hash         | ${hash}             |
      | photos_list  | ${photos_list}      |
      | v            | ${v}                |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | photo_id | $.response[:1].id       |
      | owner_id | $.response[:1].owner_id |

    # Сделать фотографию обложкой альбома
    Пусть создать запрос
      | method | path                     |
      | GET    | /method/photos.makeCover |
    И добавить query параметры
      | access_token | ${token}            |
      | v            | ${v}                |
      | owner_id     | ${owner_id}         |
      | photo_id     | ${photo_id}         |
      | album_id     | ${album_private_id} |
    Когда отправить запрос
    Тогда статус код 200

    #Прокомментировать фотографию
    Пусть создать запрос
      | method | path                         |
      | GET    | /method/photos.createComment |
    И добавить query параметры
      | access_token | ${token}         |
      | v            | ${v}             |
      | owner_id     | ${owner_id}      |
      | photo_id     | ${photo_id}      |
      | message      | ${message_photo} |
    Когда отправить запрос
    Тогда статус код 200

  # Добавить отметку на фотографию
    Пусть создать запрос
      | method | path                  |
      | GET    | /method/photos.putTag |
    И добавить query параметры
      | access_token | ${token}    |
      | v            | ${v}        |
      | owner_id     | ${owner_id} |
      | photo_id     | ${photo_id} |
      | user_id      | ${user_id}  |
      | x            | ${x}        |
      | y            | ${y}        |
      | x2           | ${x2}       |
      | y2           | ${y2}       |
    Когда отправить запрос
    Тогда статус код 200

    # Создать публичный альбом
    И создать запрос
      | method | path                       |
      | GET    | /method/photos.createAlbum |
    И добавить query параметры
      | access_token    | ${token}              |
      | v               | ${v}                  |
      | title           | ${title_public}       |
      | description     | ${description_public} |
      | privacy_view    | all                   |
      | privacy_comment | all                   |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | album_public_id | $.response.id |

    # Перенести туда фотографию
    Пусть создать запрос
      | method | path                |
      | GET    | /method/photos.move |
    И добавить query параметры
      | access_token    | ${token}           |
      | v               | ${v}               |
      | target_album_id | ${album_public_id} |
      | photo_id        | ${photo_id}        |
    Когда отправить запрос
    Тогда статус код 200

   # Удалить первый альбом
    Пусть создать запрос
      | method | path                       |
      | GET    | /method/photos.deleteAlbum |
    И добавить query параметры
      | access_token | ${token}            |
      | v            | ${v}                |
      | album_id     | ${album_private_id} |
    Когда отправить запрос
    Тогда статус код 200

    # Проверить альбомы
    Пусть создать запрос
      | method | path                     |
      | GET    | /method/photos.getAlbums |
    И добавить query параметры
      | access_token | ${token} |
      | v            | ${v}     |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | actual_album_count       | $.response.count                 |
      | actual_album_title       | $.response.items[:1].title       |
      | actual_album_description | $.response.items[:1].description |
    И сравнить значения
      | ${actual_album_count}       | == | 1                     |
      | ${actual_album_title}       | == | ${title_public}       |
      | ${actual_album_description} | == | ${description_public} |











