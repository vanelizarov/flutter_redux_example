// Dumb server made just for testing
// Made with love and copypasting

import express from 'express'
import bodyParser from 'body-parser'
import morgan from 'morgan'
import uuid from 'uuid/v1'
import bcrypt from 'bcrypt'

const PORT = process.env.PORT || 1616
const SALT_ROUNDS = 10

class User {
  id: string
  username: string
  hash: string

  constructor(username: string, hash: string) {
    this.id = uuid()
    this.username = username
    this.hash = hash
  }

  prepare() {
    return {
      username: this.username,
      id: this.id
    }
  }
}

const users = new Map<String, User>()

const app = express()

app.use(bodyParser.json())
app.use(morgan('dev'))

app.post('/register', async (req, res) => {
  const { username, password } = req.body

  if (!username) {
    return res.status(400).json({
      message: 'Username not specified'
    })
  }

  if (!password) {
    return res.status(400).json({
      message: 'Password not specified'
    })
  }


  try {
    const dbUser = users.get(username)

    if (dbUser) {
      return res.status(200).json(dbUser.prepare())
    }

    const hash = await bcrypt.hash(password, SALT_ROUNDS)
    const user = new User(username, hash)

    users.set(username, user)

    return res.status(200).json(user.prepare())
  } catch (err) {
    return res.status(500).json({
      message: 'Something went wrong'
    })
  }
})

app.post('/login', async (req, res) => {
  const { username, password } = req.body

  if (!username) {
    return res.status(400).json({
      message: 'Username not specified'
    })
  }

  if (!password) {
    return res.status(400).json({
      message: 'Password not specified'
    })
  }

  try {
    const user = users.get(username)

    if (!user) {
      return res.status(401).json({
        message: 'No such user'
      })
    }

    const hashesMatch = await bcrypt.compare(password, user.hash)

    if (hashesMatch) {
      return res.status(200).json(user.prepare())
    }

    return res.status(401).json({
      message: 'Incorrect password'
    })

  } catch (err) {
    return res.status(500).json({
      message: 'Something went wrong'
    })
  }
})

app.listen(PORT, () => {
  console.log(`App listening on :${PORT}`)
})