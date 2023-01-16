import axios from "axios"
import { parseMetadata } from "node-meta-parser"
import express from "express"

const app = express()
const PORT = process.env.NODE_PORT || 3300

app.get("/", (_, res): void => {
  res.status(200).send("Hello World!")
})

app.get("/metadata", async(_, res): Promise<void> => {
  const { data: rawHtml } = await axios.get("https://ogp.me/")
  const metadata = parseMetadata(rawHtml, ["og:title", "og:type", "og:url", "og:image", "og:description"])
  res.status(200).json(metadata)
})

app.get("/check", async(_, res): Promise<void> => {
  res.status(200).send("OK LET'S GO!")
})

app.get("/health", async (_, res): Promise<void> => {
  res.status(200).send("OK")
})

app.get("*", async (_, res): Promise<void> => {
  res.status(404).send("Not Found")
})

app.listen(PORT, (): void => {
  console.log(`Example app listening on port ${PORT}`)
})
