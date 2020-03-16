import React, { useState } from 'react'
import { Link } from 'react-router-dom'

import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Button from '@material-ui/core/Button'
import CircularProgress from '@material-ui/core/CircularProgress'

const NewAccount = () => {
  const [userData, setUserData] = useState({
      name: '',
      errors: {}
  })

  const [loading, setLoading] = useState(false)
  const [submitted, setSubmitted] = useState(false)
  const [showAdvanced,setShowAdvanced] = useState(false)

  const handleChange = event => {
      setUserData({...userData, [event.target.name]: event.target.value})
  }

  const submit = () => {
      console.log("triggered")
      setLoading(true)
      const newUserData = {
          ...userData
      }
      axios.post('/create', newUserData)
          .then(res => {
              console.log(res.data)
              history.push('/')
          })
          .catch(err => {
              console.log(err)
              setUserData({
                  ...userData,
                  errors: err.response.data
              })
          })
      setLoading(false)
  }

  return(
    <>
      <div className="create">
        <Typography>Create new account</Typography>
        <form noValidate onSubmit={submit}>
            <TextField id="name" name="name" type="text" label="name"
                className="create__text" value={userData.name}
                onChange={handleChange} helperText={userData.errors.email}
                error={userData.errors.name ? true : false} fullWidth />
            <Typography>Import existing address / other advanced account creation options</Typography>
            {
              !showAdvanced ?
              <Button type="" variant="contained" color="primary" className="create__advancedbutton"
                onClick={setShowAdvanced}>
                Advanced
              </Button>
              :
              <TextField id="address" name="address" type="text" label="address"
              className="create_address" value={userData.address}
              error={userData.errors.address ? true : false} fullWidth />
              // some kind of Aragon DAO options
            }
            <br />
            <Button type="submit" variant="contained" color="primary" className={classes.button} disabled={loading}>
                Sign Up
                {loading && (
                    <CircularProgress size={30} className={classes.progress}/>
                )}
            </Button>
            <br />
            <small>Already have an account?<Link to="/login">Log In!</Link></small>
        </form>
      </div>
    </>
  )
}
