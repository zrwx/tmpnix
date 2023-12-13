#define Forward(...) std::forward<decltype(__VA_ARGS__)>(__VA_ARGS__)

template<typename UnknownType, typename ReferenceType>
concept SubtypeOf = std::same_as<std::decay_t<UnknownType>, ReferenceType> || std::derived_from<std::decay_t<UnknownType>, ReferenceType>;

template<typename UnknownType, typename ...ReferenceTypes>
concept AnyOf = (SubtypeOf<UnknownType, ReferenceTypes> || ...);

template<typename UnknownType, typename ...ReferenceTypes>
concept AnyBut = !AnyOf<UnknownType, ReferenceTypes...>;

template<typename UnknownType, typename ReferenceType>
concept ExplicitlyConvertibleTo = requires(UnknownType x) { static_cast<ReferenceType>(Forward(x)); };

template<typename UnknownType>
concept BuiltinArray = std::is_array_v<std::remove_cvref_t<UnknownType>>;

template<typename UnknownType>
concept Advanceable = requires(UnknownType x) { ++x; };

template<typename UnknownType>
concept Iterable = BuiltinArray<UnknownType> || requires(UnknownType x) {
	{ x.begin() }->Advanceable;
	{ *x.begin() }->AnyBut<void>;
	{ x.begin() != x.end() }->ExplicitlyConvertibleTo<bool>;
};

template<typename UnknownType, auto Index>
concept ReachableAt = requires(UnknownType x) { { std::get<Index>(x) }->AnyBut<void>; };

template<typename UnknownType>
concept Expandable = []<auto ...x>(std::index_sequence<x...>) {
  return (ReachableAt<UnknownType, x> && ...);
}(std::make_index_sequence<std::tuple_size<std::remove_cvref_t<UnknownType>>{}>{});

template<typename UnknownType>
struct ExtractInnermostTypeArgument {
	using IrreducibleType = UnknownType;
};

template<Iterable UnknownType>
    requires (BuiltinArray<UnknownType> == false)
struct ExtractInnermostTypeArgument<UnknownType> {
	using InnerType = std::remove_cvref_t<decltype(*std::declval<UnknownType>().begin())>;
	using IrreducibleType = typename ExtractInnermostTypeArgument<InnerType>::IrreducibleType;
};

template<typename UnknownType, auto Length>
struct ExtractInnermostTypeArgument<UnknownType[Length]> {
	using InnerType = std::remove_cvref_t<UnknownType>;
	using IrreducibleType = typename ExtractInnermostTypeArgument<InnerType>::IrreducibleType;
};

template<typename UnknownType>
using ExtractInnermostElementType = typename ExtractInnermostTypeArgument<std::remove_cvref_t<UnknownType>>::IrreducibleType;

auto& operator<<(SubtypeOf<std::ostream> auto&,
                 const Expandable auto& Container)
    requires (requires { { Container }->Iterable; } == false);

auto& operator<<(SubtypeOf<std::ostream> auto& Printer,
                 const Iterable auto& Container)
    requires requires { Printer << std::declval<ExtractInnermostElementType<decltype(Container)>>(); } {
	auto [Startpoint, Endpoint] = [&]{
		if constexpr (requires { { Container }->BuiltinArray; }) {
			return std::tuple{ Container, Container + sizeof(Container) / sizeof(Container[0]) };
    } else {
			return std::tuple{ std::begin(Container), std::end(Container) };
    }
	}();
	Printer << "[";
	for (auto Cursor = Startpoint; Cursor != Endpoint; ++Cursor)
		if (Cursor != Startpoint)
			Printer << ", " << *Cursor;
		else
			Printer << *Cursor;
	Printer << "]";
	return Printer;
}

auto& operator<<(SubtypeOf<std::ostream> auto& Printer,
                 const Expandable auto& Container)
    requires (requires { { Container } -> Iterable; } == false) {
	Printer << "(";

	if constexpr (std::tuple_size_v<std::decay_t<decltype(Container)>> != 0) {
    auto applicand = [&](auto&& FirstElement, auto&& ...Elements) {
			Printer << FirstElement;
      auto f = [&](auto&& x){ Printer << ", " << x; };
			(f(Elements), ...);
		};
		std::apply(applicand, Container);
  }

	Printer << ")";
	return Printer;
}
