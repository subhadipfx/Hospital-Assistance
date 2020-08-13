<form method="POST" action="{{route('admin.add')}}">
    @csrf
    <div class="form-group">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" class="form-control" value="{{old('name')}}">
    </div>
    <div class="form-group">
        <label for="email">User Email:</label>
        <input type="text" id="email" name="email" class="form-control" value="{{old('email')}}">
    </div>
    <div class="form-group">
        <label for="password">User Password:</label>
        <input type="password" id="password" name="password" class="form-control">
    </div>
    <div class="text-center">
        <button type="submit" class="btn btn-primary">ADD</button>
    </div>
</form>
