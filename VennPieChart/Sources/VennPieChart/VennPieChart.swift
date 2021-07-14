import UIKit

public class VennPieChartView: UIView {
    
    public var positiveNumbers = 0
    public var positiveColor = UIColor.green
    public var negativeNumbers = 0
    public var negativeColor = UIColor.red
    
    @IBInspectable public var numberOfPositiveValues: Int {
        get {
            return positiveNumbers
        }
        set {
            positiveNumbers = newValue
        }
    }
    
    @IBInspectable public var positiveArcColor: UIColor? {
        get {
            return UIColor(cgColor: positiveColor.cgColor)
        }
        set {
            if let newValue = newValue {
                positiveColor = newValue
            }
        }
    }
    
    @IBInspectable public var numberOfNegativeValues: Int {
        get {
            return negativeNumbers
        }
        set {
            negativeNumbers = newValue
        }
    }
    @IBInspectable public var negativeArcColor: UIColor? {
        get {
            return UIColor(cgColor: negativeColor.cgColor)
        }
        set {
            if let newValue = newValue {
                negativeColor = newValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.drawArcWithParams(plottingView: self, count: self.positiveNumbers-1, isClockWise: true)
            self.drawArcWithParams(plottingView: self, count: self.negativeNumbers-1, isClockWise: false)
        }
    }
    
    /// Drawing number Arc in given View clockwise or anticlockwise
    private func drawArcWithParams(plottingView: UIView, count: Int, isClockWise: Bool) {
        var dynamicRadious:CGFloat = 0.0
        var value = 9
        var greenValue = 105.0
        var redValue = 30.0
        var blueValue = 57.0
        var arrLayers = [CAShapeLayer]()
        
        for _ in 0...count {
            //Drawing unfilled Arcs
            let center = CGPoint (x: plottingView.frame.size.width / 2,
                                  y: plottingView.frame.size.height / 2)
            
            let circleRadius = 60 + dynamicRadious + (((plottingView.frame.size.width / 2) - 60) / CGFloat(count + 1) / 2)
            
            let circlePathEmpty = UIBezierPath(arcCenter: center, radius: circleRadius,
                                               startAngle: CGFloat(Double.pi),
                                               endAngle: .zero,
                                               clockwise: isClockWise)
            
            let semiCircleLayerEmpty = CAShapeLayer()
            semiCircleLayerEmpty.path = circlePathEmpty.cgPath
            blueValue = blueValue - 3
            semiCircleLayerEmpty.strokeColor = UIColor.init(red: 34.0/255.0, green: CGFloat(blueValue/255.0), blue: 71.0/255.0, alpha: 1.0).cgColor
            semiCircleLayerEmpty.fillColor = UIColor.clear.cgColor
            semiCircleLayerEmpty.lineWidth = ((plottingView.frame.size.width / 2) - 60) / CGFloat(count + 1)
            semiCircleLayerEmpty.strokeStart = 0
            semiCircleLayerEmpty.strokeEnd  = 1
            plottingView.layer.addSublayer(semiCircleLayerEmpty)
            
            
            // Drawing Filled Arcs with given value
            value -= 1
            let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle:CGFloat(Double.pi), endAngle: isClockWise ? CGFloat(-((Double(value))/3.0)) : CGFloat(((Double(value))/3.0)), clockwise: isClockWise)
            
            let semiCircleLayer   = CAShapeLayer()
            semiCircleLayer.path = circlePath.cgPath
            greenValue = greenValue + 15.0
            redValue = redValue + 25.0
            semiCircleLayer.strokeColor = isClockWise ? UIColor(red: 48.0/255.0, green: CGFloat(greenValue/255.0), blue: 83.0/255.0, alpha: 1.0).cgColor : UIColor(red: CGFloat(redValue/255.0), green: 35.0/255.0, blue: 25.0/255.0, alpha: 1.0).cgColor
            semiCircleLayer.fillColor = UIColor.clear.cgColor
            semiCircleLayer.lineWidth = ((plottingView.frame.size.width / 2) - 60) / CGFloat(count + 1) //12
            dynamicRadious = dynamicRadious + ((plottingView.frame.size.width / 2) - 60) / CGFloat(count + 1) //12
            semiCircleLayer.strokeStart = 0
            semiCircleLayer.strokeEnd  = 1
            
            // Saving layers in array to show text value
            arrLayers.append(semiCircleLayer)
            plottingView.layer.addSublayer(semiCircleLayer)
        }
        
        // Writing circular text along with Drawn Arc
        var i = 0
        dynamicRadious = 0.0
        for layer in arrLayers{
            let circleRadius = 60 + dynamicRadious + (((plottingView.frame.size.height / 2) - 60) / CGFloat(count + 1) / 2)
            drawCurvedString(on: layer, text: NSAttributedString(
                string: isClockWise ? "Clockwise Text \(i)" :  "Anticlockwise Text \(i)",
                attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: (((plottingView.frame.size.height / 2) - 60) / CGFloat(count + 1)/2))
                ]), angle: isClockWise ? CGFloat(-((Double(8))/3.0 * 2.5) + 0.50) : CGFloat(-((Double(83.5))/3.0 * 2.5) + 0.50), radius: circleRadius, plottingViwe: plottingView, isClockwise: isClockWise)
            dynamicRadious = dynamicRadious + ((plottingView.frame.size.height / 2) - 60) / CGFloat(count + 1)
            i += 1
        }
    }
    
    private func drawCurvedString(on layer: CALayer, text: NSAttributedString, angle: CGFloat, radius: CGFloat, plottingViwe: UIView, isClockwise: Bool) {
        var radAngle = angle.radians
        
        let perimeter: CGFloat = 2 * .pi * radius
        
        var textRotation: CGFloat = 0
        var textDirection: CGFloat = 0
        
        if angle > CGFloat(10).radians, angle < CGFloat(170).radians {
            // bottom string
            textRotation = 0.5 * .pi
            textDirection = -2 * .pi
            radAngle = isClockwise ? angle/2 : -angle/2 //textAngle / 2
        } else {
            // top string
            textRotation = CGFloat(isClockwise ? (1.5 * .pi) : (1.5 * -.pi))
            textDirection = CGFloat(isClockwise ? 2.0 * .pi : 2.0 * -.pi)
            radAngle = isClockwise ? angle/2 : -angle/2 //textAngle / 2
        }
        
        for c in 0..<text.length {
            let letter = text.attributedSubstring(from: NSRange(c..<c+1))
            let charSize = letter.boundingRect(
                with: CGSize(width: .max, height: .max),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil)
                .integral
                .size
            
            let letterAngle = (charSize.width / perimeter) * textDirection
            let x = radius * cos(radAngle + (letterAngle / 2))
            let y = radius * sin(radAngle + (letterAngle / 2))
            
            let singleChar = drawText(
                on: layer,
                text: letter,
                frame: CGRect(
                    x: (layer.frame.size.width / 2) - (charSize.width / 2) + x + (plottingViwe.frame.size.width / 2),
                    y: (layer.frame.size.height / 2) - (charSize.height / 2) + y + (plottingViwe.frame.size.height / 2),
                    width: charSize.width,
                    height: charSize.height))
            layer.addSublayer(singleChar)
            singleChar.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: radAngle - textRotation))
            radAngle += letterAngle
        }
    }
    
    private func drawText(on layer: CALayer, text: NSAttributedString, frame: CGRect) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.frame = frame
        textLayer.string = text
        //textLayer.backgroundColor = UIColor.yellow.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        textLayer.contentsScale = UIScreen.main.scale
        return textLayer
    }
}
