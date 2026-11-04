import express from "express"

// Creates the express application
const app = express()

const PORT = process.env.PORT || 3000

app.listen(PORT, () => {console.log("Hello world")})