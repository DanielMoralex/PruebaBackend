from flask import Flask, request, jsonify
import pymzn

pymzn.config['minizinc'] = r"C:\Program Files\MiniZinc\minizinc.exe"

app = Flask(__name__)

@app.route('/solve', methods=['GET', 'POST'])
def solve():
    try:
        # Recibir datos JSON de la app Android
        data = request.get_json()
        
        # Modelo de MiniZinc (puedes cambiarlo según tu necesidad)
        model = """
        var 0..100: x;
        var 0..100: y;
        constraint x + y == {sum};
        solve maximize x;
        output [ "x = " ++ show(x) ++ ", y = " ++ show(y) ];
        """.format(sum=data.get("sum", 10))  # Suma que recibimos del cliente
        
        # Guardar el modelo en un archivo temporal
        with open("model.mzn", "w") as f:
            f.write(model)
        
        # Resolver usando pymzn
        result = pymzn.minizinc("model.mzn")

        solution_list = [str(sol) for sol in result]
        
        # Devolver la solución en formato JSON
        return jsonify({"solution": solution_list})

    except Exception as e:
        return jsonify({"error": str(e)})
def handle_request():
    if request.method == 'GET':
        return jsonify({"error": "Usa POST"}), 405  # Puedes cambiarlo para manejar GET si lo deseas
    elif request.method == 'POST':
        data = request.json  # Procesar datos del POST
        return jsonify({"message": "POST recibido", "data": data})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
