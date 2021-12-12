#language:ru
@Test_conversation

Функционал: Работа с беседой
  - Создать беседу
  - Пометить беседу как "важно"
  - Переименовать беседу в "Ну очень важная беседа"
  - Добавить нового участника
  - Написать в группу сообщение - "Это очень важная беседа, выходить!"
  - Отредактировать сообщение - "Это очень важная беседа, НЕ выходить!"
  - Закрепить сообщение
  - Написать в группу сообщение - "А нет, лучше в группу"

  Сценарий: Работа с беседой
    * создать контекстные переменные
      | token          | токен standalone                      |
      | group_token    | токен группы для бесед                |
      | login          | логин                                 |
      | password       | пароль                                |
      | v              | 5.131                                 |
      | user1_id       | 690043267                             |
      | user2_id       | 633452901                             |
      | group_id       | 209316238                             |
      | chat_title     | Тестовая беседа                       |
      | new_chat_title | Ну очень важная беседа                |
      | message        | Это очень важная беседа, выходить!    |
      | edited_message | Это очень важная беседа, НЕ выходить! |
      | group_message  | А нет, лучше в группу                 |

    # Создать беседу
    Пусть создать запрос
      | method | path                        |
      | GET    | /method/messages.createChat |
    И добавить query параметры
      | access_token | ${group_token} |
      | v            | ${v}           |
      | user_ids     | ${user1_id}    |
      | title        | ${chat_title}  |
      | group_id     | ${group_id}    |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | chat_id | $.response |

    # Пометить беседу как "важно"
    Пусть создать запрос
      | method | path                                         |
      | GET    | /method/messages.markAsImportantConversation |
    И добавить query параметры
      | access_token | ${group_token} |
      | v            | ${v}           |
      | peer_id      | ${chat_id}     |
      | important    | 1              |
      | group_id     | ${group_id}    |
    Когда отправить запрос
    Тогда статус код 200

    # Переименовать беседу в "Ну очень важная беседа"
    Пусть создать запрос
      | method | path                      |
      | GET    | /method/messages.editChat |
    И добавить query параметры
      | access_token | ${group_token}    |
      | v            | ${v}              |
      | chat_id      | ${chat_id}        |
      | title        | ${new_chat_title} |
    Когда отправить запрос
    Тогда статус код 200

    # Получить invite в беседу
    Пусть создать запрос
      | method | path                           |
      | GET    | /method/messages.getInviteLink |
    И создать контекстные переменные
      | chat_id_patched | ${chat_id} |
    И добавить query параметры
      | access_token | ${group_token}     |
      | v            | ${v}               |
      | peer_id      | ${chat_id_patched} |
      | reset        | 1                  |
      | group_id     | ${group_id}        |
    Когда отправить запрос
    Тогда статус код 200
    И извлечь данные
      | invite_link | $.response.link |

    # Перейти по invite link
    Пусть залогиниться на сайт "https://vk.com/" с логином "${login}" и паролем "${password}"
    И подождать 1 сек
    И перейти по ссылке "${invite_link}"
    И присоединиться к беседе

    # Написать в группу сообщение - "Это очень важная беседа, выходить!"
    Пусть создать запрос
      | method | path                  |
      | GET    | /method/messages.send |
    И сгенерировать переменные
      | random_id | DDDDD |
    И добавить query параметры
      | access_token | ${group_token}     |
      | v            | ${v}               |
      | group_id     | ${group_id}        |
      | random_id    | ${random_id}       |
      | peer_id      | ${chat_id_patched} |
      | message      | ${message}         |
    Когда отправить запрос
    Тогда статус код 200

    # Отредактировать сообщение - "Это очень важная беседа, НЕ выходить!"
    Пусть создать запрос
      | method | path                  |
      | GET    | /method/messages.edit |
    И добавить query параметры
      | access_token | ${group_token}     |
      | v            | ${v}               |
      | peer_id      | ${chat_id_patched} |
      | message_id   | ${random_id}       |
      | message      | ${edited_message}  |
    Когда отправить запрос
    Тогда статус код 200

        # Закрепить сообщение
    Пусть создать запрос
      | method | path                 |
      | GET    | /method/messages.pin |
    И добавить query параметры
      | access_token | ${group_token}     |
      | v            | ${v}               |
      | peer_id      | ${chat_id_patched} |
      | message_id   | ${random_id}       |
    Когда отправить запрос
    Тогда статус код 200

        # Написать в группу сообщение - "А нет, лучше в группу"
    Пусть создать запрос
      | method | path                  |
      | GET    | /method/messages.send |
    И сгенерировать переменные
      | random_id | DDDDD |
    И добавить query параметры
      | access_token | ${group_token}     |
      | v            | ${v}               |
      | group_id     | ${group_id}        |
      | random_id    | ${random_id}       |
      | peer_id      | ${chat_id_patched} |
      | message      | ${group_message}   |
    Когда отправить запрос
    Тогда статус код 200





