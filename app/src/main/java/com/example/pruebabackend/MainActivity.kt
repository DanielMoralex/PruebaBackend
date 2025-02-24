package com.example.pruebabackend

import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import kotlinx.coroutines.*
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import android.widget.TextView


class MainActivity : AppCompatActivity() {
    private lateinit var tvResponse: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        tvResponse = findViewById(R.id.tvResponse)

        // Llamar a la función para enviar los datos al servidor
        sendRequest(20)
    }

    private fun sendRequest(sum: Int) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                // Reemplaza con la IP correcta
                val url = URL("http://10.195.179.198:5000/solve")

                // Crea el objeto JSON
                val jsonInput = JSONObject().apply { put("sum", sum) }

                // Abrir la conexión HTTP
                with(url.openConnection() as HttpURLConnection) {
                    requestMethod = "POST"
                    doOutput = true
                    setRequestProperty("Content-Type", "application/json")

                    // Escribir el cuerpo de la solicitud
                    outputStream.write(jsonInput.toString().toByteArray())

                    // Leer la respuesta
                    val response = inputStream.bufferedReader().use { it.readText() }

                    // Mostrar la respuesta en Logcat
                    Log.d("MiniZincResponse", response)

                    // Actualizar la UI en el hilo principal
                    withContext(Dispatchers.Main) {
                        tvResponse.text = "Respuesta: $response"
                    }
                }
            } catch (e: Exception) {
                // Manejar errores
                Log.e("Error", e.toString())

                withContext(Dispatchers.Main) {
                    tvResponse.text = "Error: ${e.message}"
                }
            }
        }
    }
}
