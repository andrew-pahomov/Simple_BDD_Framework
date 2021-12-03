#language:ru
@Test_profile

Функционал: Редактирование профиля VK
  - Получить всю информацию о текущем профиле
  - Заполнить недостающую информацию
  - Сменить фото профиля на любую другую

  Сценарий: Выполнение Get запроса к API VK, проверка полученной информации, дополнение недостающих полей

      # сгенерировать случайную информацию в профиль
    Пусть сгенерировать случайную информацию о профиле
      | first_name       |
      | id               |
      | last_name        |
      | home_town        |
      | status           |
      | bdate            |
      | bdate_visibility |
      | phone            |
      | relation         |
      | sex              |

      # добавить реальный токен приложения vk вместо токен
    И создать контекстные переменные
      | token | токен |
      | v     | 5.131 |

    # получить информацию из профиля
    И создать запрос
      | method | path                           |
      | GET    | /method/account.getProfileInfo |
    И добавить query параметры
      | access_token | ${token} |
      | v            | ${v}     |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | first_name       | $.response.first_name       |
      | last_name        | $.response.last_name        |
      | status           | $.response.status           |
      | id               | $.response.id               |
      | home_town        | $.response.home_town        |
      | bdate            | $.response.bdate            |
      | bdate_visibility | $.response.bdate_visibility |
      | phone            | $.response.phone            |
      | relation         | $.response.relation         |
      | sex              | $.response.sex              |

     # дополнить информацию в профиле
    И определить недостающую информацию
    И создать запрос
      | method | path                            |
      | GET    | /method/account.saveProfileInfo |
    И добавить query параметры для добавления информации
      | access_token | ${token} |
      | v            | ${v}     |
    Когда отправить запрос
    Тогда статус код 200
    И сравнить значения
      | ${first_name}       | != | null |
      | ${last_name}        | != | null |
      | ${status}           | != | null |
      | ${id}               | != | null |
      | ${home_town}        | != | null |
      | ${bdate}            | != | null |
      | ${bdate_visibility} | != | null |
      | ${phone}            | != | null |
      | ${relation}         | != | null |
      | ${sex}              | != | null |

  Сценарий: Изменение фото профиля
    # получить ссылку для загрузки фото
    # добавить реальный токен приложения vk вместо токен
    Пусть создать контекстные переменные
      | token | токен |
      | v     | 5.131 |
    И создать запрос
      | method | path                                     |
      | GET    | /method/photos.getOwnerPhotoUploadServer |
    И добавить query параметры
      | access_token | ${token} |
      | v            | ${v}     |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | upload_url | $.response.upload_url |

    # загрузить фото
    Пусть создать запрос
      | method | url           | filePath             | fileName |
      | POST   | ${upload_url} | .\src\test\resources | img.png  |
    Когда отправить multipart-form-data запрос
    Тогда статус код 200
    И извлечь данные
      | server | $.server |
      | photo  | $.photo  |
      | hash   | $.hash   |

    # подтвердить фото
    Пусть создать запрос
      | method | path                          |
      | POST   | /method/photos.saveOwnerPhoto |
    И добавить multipart-form-data query параметры
      | access_token | ${token}   |
      | v            | ${v}       |
      | server       | ${server} |
      | photo        | ${photo}  |
      | hash         | ${hash}   |
    Когда отправить запрос
    Тогда статус код 200