const app = require('express')()

app.get('/', (req, res) => res.send('Hello from the server'))

const PORT = process.env.PORT || 7777

app.listen(PORT, () => console.log(`Server started on port ${PORT}`))
