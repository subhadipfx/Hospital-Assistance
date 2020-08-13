<?php


namespace App\Http\Controllers\Auth;


use App\Http\Controllers\Controller;
use App\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class ApiAuthController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:api', ['except' => ['authenticate','unAuthorized','register']]);
        auth()->shouldUse('api');
    }
    protected function validator(array $data)
    {
        return Validator::make($data, [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'string', 'min:8'],
            'phone' => ['required','numeric']
        ]);
    }

    public function register(){
        try{
            $validator = $this->validator(request(['name','email','phone','password']));
            if($validator->fails()){
                throw new \Exception(json_encode($validator->errors()->all()));
            }
            User::query()->create([
                "name" => request()->name,
                "email" => request()->email,
                "phone" => request()->phone,
                "password" =>  Hash::make(request()->password),
                "role" => "end_user"
            ]);
        }catch(\Exception $exception){
            return response(['message' => "Failed To Create User","reason" => json_decode($exception->getMessage())],400);
        }
        $token = auth()->attempt(request(['email', 'password']),['exp' => now()->addYear()->timestamp]);

        return $this->respondWithToken($token);
    }

    public function authenticate()
    {
        $credentials = request(['email', 'password']);

        if (! $token = auth()->attempt($credentials,['exp' => now()->addYear()->timestamp])) {
            return $this->unAuthorized();
        }

        return $this->respondWithToken($token);
    }

    public function unAuthorized()
    {
        return response()->json(['error' => 'Unauthorized'], 401);
    }

    public function me()
    {
        return response()->json(auth()->user());
    }

    public function logout()
    {
        auth()->logout();

        return response()->json(['message' => 'Successfully logged out'],204);
    }

    protected function respondWithToken($token)
    {
        return response()->json([
            'access_token' => $token,
            'refresh_token' => auth()->refresh(),
            'user' => auth()->user()
        ],200);
    }
}
