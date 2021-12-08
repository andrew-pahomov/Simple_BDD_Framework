#language:ru
@Test_topic

Функционал: Работа с обсуждениями
  - Создать группу
  - Добавить новую тему для обсуждений
  - Закрепить тему в списке обсуждений группы
  - Написать 3 комментария с произвольным текстом
  - Поменять текст в предпоследнем комментарии
  - Удалить первый комментарий

  Сценарий:
    # Создать группу
    Пусть создать контекстные переменные
      | token             | 94b8805d2b8c1fcd94d04ae4558336a7b2ead1337cc2ea7452de340443cfa04400c58fee43baaa5f3e7b7                 |
      | v                 | 5.131                            |
      | group_title       | Тестовая группа для обсуждений   |
      | group_type        | group                            |
      | group_description | Группа для обсуждений            |
      | topic_title       | Кто может процитировать Гамлета? |
    И создать запрос
      | method | path                  |
      | GET    | /method/groups.create |
    И добавить query параметры
      | access_token | ${token}             |
      | title        | ${group_title}       |
      | type         | ${group_type}        |
      | description  | ${group_description} |
      | v            | ${v}                 |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | group_id           | $.response.id   |
      | actual_group_title | $.response.name |
      | actual_group_type  | $.response.type |
    И сравнить значения
      | ${group_title} | == | ${actual_group_title} |
      | ${group_type}  | == | ${actual_group_type}  |

    # Добавить новую тему для обсуждений
    Пусть создать запрос
      | method | path                   |
      | GET    | /method/board.addTopic |
    И добавить query параметры
      | access_token | ${token}       |
      | title        | ${topic_title} |
      | text         | ${topic_title} |
      | group_id     | ${group_id}    |
      | v            | ${v}           |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | topic_id | $.response |

    # Закрепить тему в списке обсуждений группы
    Пусть создать запрос
      | method | path                   |
      | GET    | /method/board.fixTopic |
    И добавить query параметры
      | access_token | ${token}    |
      | topic_id     | ${topic_id} |
      | group_id     | ${group_id} |
      | v            | ${v}        |
    Когда отправить запрос
    Тогда статус код 200

    # Написать 3 комментария с произвольным текстом
    Пусть сгенерировать случайную переменную
      | message1_text |
    И создать запрос
      | method | path                        |
      | GET    | /method/board.createComment |
    И добавить query параметры
      | access_token | ${token}         |
      | topic_id     | ${topic_id}      |
      | group_id     | ${group_id}      |
      | message      | ${message1_text} |
      | v            | ${v}             |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | comment1_id | $.response |
    Пусть сгенерировать случайную переменную
      | message2_text |
    И создать запрос
      | method | path                        |
      | GET    | /method/board.createComment |
    И добавить query параметры
      | access_token | ${token}         |
      | topic_id     | ${topic_id}      |
      | group_id     | ${group_id}      |
      | message      | ${message2_text} |
      | v            | ${v}             |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | comment2_id | $.response |
    Пусть сгенерировать случайную переменную
      | message3_text |
    И создать запрос
      | method | path                        |
      | GET    | /method/board.createComment |
    И добавить query параметры
      | access_token | ${token}         |
      | topic_id     | ${topic_id}      |
      | group_id     | ${group_id}      |
      | message      | ${message3_text} |
      | v            | ${v}             |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | comment3_id | $.response |

    # Поменять текст в предпоследнем комментарии
    Пусть сгенерировать случайную переменную
      | message4_text |
    И создать запрос
      | method | path                      |
      | GET    | /method/board.editComment |
    * добавить query параметры
      | access_token | ${token}         |
      | topic_id     | ${topic_id}      |
      | group_id     | ${group_id}      |
      | comment_id   | ${comment2_id}   |
      | message      | ${message4_text} |
      | v            | ${v}             |
    * отправить запрос
    * статус код 200

    # Удалить первый комментарий
    Пусть создать запрос
      | method | path                        |
      | GET    | /method/board.deleteComment |
    И добавить query параметры
      | access_token | ${token}       |
      | topic_id     | ${topic_id}    |
      | group_id     | ${group_id}    |
      | comment_id   | ${comment1_id} |
      | v            | ${v}           |
    Когда отправить запрос
    Тогда статус код 200

    # Проверить список тем
    Пусть создать запрос
      | method | path                      |
      | GET    | /method/board.getComments |
    И добавить query параметры
      | access_token | ${token}    |
      | topic_id     | ${topic_id} |
      | group_id     | ${group_id} |
      | sort         | asc         |
      | v            | ${v}        |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | topics_count    | $.response.count         |
      | actual_message1 | $.response.items[0].text |
      | actual_message2 | $.response.items[1].text |
      | actual_message3 | $.response.items[2].text |
    И сравнить значения
      | ${topics_count}    | == | 3                |
      | ${actual_message1} | == | ${topic_title}   |
      | ${actual_message2} | == | ${message4_text} |
      | ${actual_message3} | == | ${message3_text} |



