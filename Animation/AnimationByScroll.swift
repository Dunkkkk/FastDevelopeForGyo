import UIKit
import SnapKit

class ViewController: UIViewController, EasyToAnimation {
    
    
    var targetHeight: Double = 400
    
    var viewList: [UIView] = [UIView]()
    
    var constranitList: [(UIView, Double) -> ()] = [(UIView, Double)->()]()
    
    
    var scrollView = UIScrollView()
    let mapView = UIView()
    let contentView = UIView()
    let infoView = UIView()
    let imageView = UIView()
    let titleLabel = UIView()
    let listView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attributes()
        layout()
        updataLayout()
    }
    
    private func attributes(){
        
        scrollView.delegate = self
        scrollView.bounces = false
        
        mapView.backgroundColor = .yellow
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        
        
        infoView.backgroundColor = .blue
        
        imageView.backgroundColor = .gray
        
        titleLabel.backgroundColor = .cyan
        
        listView.backgroundColor = .orange
    }
    
    private func updataLayout(){
        
        viewList.append(mapView)
        constranitList.append({ view, y in
            view.snp.updateConstraints{
                $0.height.equalTo(400 - (400 * y))
            }
        })
        
        viewList.append(imageView)
        constranitList.append({ view, y in
            view.alpha = self.changeAlpha(y)
            view.snp.updateConstraints{
                $0.top.leading.equalToSuperview().offset(30 - (30 * y))
                $0.width.equalTo( max( self.view.frame.width * y, 100) )
                $0.height.equalTo( max(300 * y, 100) )
            }
        })
        
        viewList.append(titleLabel)
        constranitList.append({ [weak self]view, y in
            view.alpha = self!.changeAlpha(y)
            view.snp.updateConstraints{
                $0.leading.equalToSuperview().inset( min( 145 - (145 * y) , 145))
                $0.top.equalToSuperview().inset( self!.aTob(start: 50, end: Double(self!.imageView.frame.height + 15), y) )
            }
        })
        viewList.append(listView)
        constranitList.append({ view, y in
            view.alpha = self.changeAlpha(y)
            
        })
    }
    
    private func layout(){
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.edges.equalTo(0)
            $0.width.equalToSuperview()
            $0.height.equalTo(1300)
        }
        
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(400)
        }
        
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.top).inset(self.mapView.frame.height)
            $0.width.equalToSuperview()
            $0.height.equalTo(1000)
        }
        
        infoView.addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(30)
            $0.width.height.equalTo(200)
        }
        
        infoView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(100 + 30 + 15)
            $0.top.equalToSuperview().inset(50)
            $0.width.equalTo(150)
            $0.height.equalTo(50)
        }
        
        infoView.addSubview(listView)
        listView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.width.equalToSuperview().inset(30)
            $0.height.equalTo(300)
            $0.centerX.equalToSuperview()
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.contentOffset.y >= 0){
            move(contentOffset: scrollView.contentOffset.y)
            print(mapView.frame.height)
        }
    }
}

protocol EasyToAnimation {
    var targetHeight: Double { get set }
    var viewList: [UIView] { get set }
    var constranitList: [(UIView, Double) ->()] { get set }
    
    func move(contentOffset y: Double)
    func changeAlpha(_ y: Double) -> Double
    func aTob(start a: Double, end b: Double, _ y: Double) -> Double
    
}

extension EasyToAnimation{
    
    func move(contentOffset y: Double) {
        let percentY = min ( 1, max ( y / self.targetHeight , 0))
        self.viewList.enumerated().forEach { idx, element in
            self.constranitList[idx](element, percentY)
            
        }
    }
    func changeAlpha(_ y: Double) -> Double{
        if (y == 1 || y == 0) { return 1 }
        else { return  y > 0.5 ? y : 1 - y }
    }
    
    func aTob(start a: Double, end b: Double, _ y: Double) -> Double {
        if (y == 0) { return a }
        if (y == 1) { return b }
        if (a > b){
            return b + ((a - b) * y )
        }
        else {
            return a + ((b - a) * y )
        }
    }
}
