/*Vítor Simioni Conte;
Disciplina de Laboratório de Inovação;
Aplicação em Flutter básica;
Quarta feira, 20 de setembro de 2023.
*/


//Importa os pacotes
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

// criando a classe usuário, que vai conter o nome, o email e o tipo de acesso
class User {
  final String name;
  final String email;
  final String accessType;

  User({required this.name, required this.email, required this.accessType}); //aqui seria o "not null" do SQL
}

// para autentica
class LoginEvent extends Equatable {
  final User user;

  LoginEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
//armazena o estado do app
class AppState {
  final User? user;

  AppState({this.user});
}

class AppBloc extends Bloc<LoginEvent, AppState> {
  AppBloc() : super(AppState());

  @override
  Stream<AppState> mapEventToState(LoginEvent event) async* {
    yield AppState(user: event.user);
  }
}


//aqui a classe principal do aplicativo:



class MyApp extends StatelessWidget {
  final AppBloc _appBloc = AppBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => _appBloc,
        child: AccessRequestForm(),
      ),
      routes: {
        '/second_screen': (context) => SecondScreen(),
      },
    );
  }
}

class AccessRequestForm extends StatefulWidget { //para a primeira tela do aplicativo
  @override
  _AccessRequestFormState createState() => _AccessRequestFormState();
}

class _AccessRequestFormState extends State<AccessRequestForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String accessType = '';


/*os titulos abaixo falam por si só, solicitação, na label nome ele pergunta o nome, na label email ele pergunta o email
na label tipo de acesso ele pede o tipo de cesso*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitação de Aceso'),   
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome:'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Qual o seu nome?';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Insira seu email:';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Tipo de Acesso'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor, insira o tipo de acesso';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    accessType = value;
                  });
                },
              ),
              SizedBox(height: 20), //pode alterar o tamanho
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    final user = User(name: name, email: email, accessType: accessType);
                    final loginEvent = LoginEvent(user: user);
                    BlocProvider.of<AppBloc>(context).add(loginEvent);
                    Navigator.of(context).pushReplacementNamed('/second_screen');
                  }
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AppBloc>(context).state.user;

    return WillPopScope(
      onWillPop: () async => false, // aqui não deixa retornar na tela atnerior
      child: Scaffold(
        appBar: AppBar(
          title: Text('Segunda Tela'),
        ),
        body: Center(
          child: user != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Nome: ${user.name}'),
                    Text('Email: ${user.email}'),
                    Text('Tipo de Acesso: ${user.accessType}'),
                  ],
                )
              : Text('Nenhum usuário encontrado'),
        ),
      ),
    );
  }
}
