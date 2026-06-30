API Setup and Testing

1. Install gems and migrate:

```bash
bundle install
rails db:migrate
```

2. Create a teacher (Devise user) for testing or use Rails console:

```ruby
# in rails console
User.create!(email: 'teacher@example.com', password: 'password123', name: 'John', subject: 'Mathematics', role: 'teacher')
```

3. Start server:

```bash
rails server
```

4. Postman:
- Import `postman/StudentManagement.postman_collection.json`.
- Set `{{baseUrl}}` to `http://localhost:3000`.
- Call `Login (get JWT)` to receive `token`.
- For subsequent requests add header `Authorization: Bearer <token>` or set `{{token}}` in environment.

Endpoints:
- `POST /login` -> { email, password } returns `{ token }`
- `GET /teachers` `GET /teachers/:id` `POST /teachers` `PUT /teachers/:id` `DELETE /teachers/:id`
- `GET /students` `GET /students/:id` `POST /students` `PUT /students/:id` `DELETE /students/:id`
- `GET /teachers/:teacher_id/students` `POST /teachers/:teacher_id/students`

JSON error responses use `{ errors: [...] }` with status `422` or `404` as appropriate.
